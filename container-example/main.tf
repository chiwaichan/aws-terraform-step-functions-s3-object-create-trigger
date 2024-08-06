data "aws_region" "current" {}

data "aws_caller_identity" "this" {}

data "aws_ecr_authorization_token" "token" {}

locals {
  source_path_lambda_container   = "lambdas/test-container"
  path_include  = ["**"]
  path_exclude  = ["**/__pycache__/**"]
  files_include = setunion([for f in local.path_include : fileset(local.source_path_lambda_container, f)]...)
  files_exclude = setunion([for f in local.path_exclude : fileset(local.source_path_lambda_container, f)]...)
  files         = sort(setsubtract(local.files_include, local.files_exclude))

  dir_sha = sha1(join("", [for f in local.files : filesha1("${local.source_path_lambda_container}/${f}")]))
}

provider "aws" {
  region = "ap-southeast-2"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

provider "docker" {
  registry_auth {
    address  = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.name)
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

module "lambda_function_with_docker_build" {
  source = "./modules/terraform-aws-lambda"

  function_name = "${random_pet.this.id}-lambda-with-docker-build"
  description   = "My awesome lambda function with container image by modules/docker-build"

  create_package = false

  ##################
  # Container Image
  ##################
  package_type  = "Image"
  architectures = ["x86_64"]
  timeout = 300
  create_role = false
  lambda_role = aws_iam_role.lambda_s3_access_role.arn

  image_uri = module.docker_build.image_uri
}



resource "aws_iam_role" "lambda_s3_access_role" {
  name = "lambda-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_basic_execution_policy" {
  name = "lambda-basic-execution-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_access_policy" {
  name = "lambda-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = "arn:aws:s3:::source-document-bucket-name-here/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy_attachment" {
  role       = aws_iam_role.lambda_s3_access_role.name
  policy_arn = aws_iam_policy.lambda_basic_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access_policy_attachment" {
  role       = aws_iam_role.lambda_s3_access_role.name
  policy_arn = aws_iam_policy.lambda_s3_access_policy.arn
}

module "docker_build" {
  source = "./modules/docker-build"

  create_ecr_repo = true
  ecr_repo        = random_pet.this.id
  ecr_repo_lifecycle_policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep only the last 2 images",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 2
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })

  use_image_tag = false # If false, sha of the image will be used

  # use_image_tag = true
  # image_tag   = "2.0"

  source_path = local.source_path_lambda_container
  platform    = "linux/amd64"
  build_args = {
    FOO = "bar"
  }

  triggers = {
    dir_sha = local.dir_sha
  }
}


resource "random_pet" "this" {
  length = 2
}
