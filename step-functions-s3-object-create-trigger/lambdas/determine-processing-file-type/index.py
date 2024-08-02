import json

def lambda_handler(event, context):
    # Extract the source-document from the event
    source_document = event.get("source-document", "").lower()
    
    # Determine the file extension and set next_step_file_type accordingly
    if source_document.endswith((".xlsx", ".xls", ".xlsm", ".xlsb", ".xltx", ".xltm")):
        next_step_file_type = "EXCEL"
    elif source_document.endswith(".pdf"):
        next_step_file_type = "PDF"
    else:
        next_step_file_type = "UNKNOWN"
    
    return {
        "next_step_file_type": next_step_file_type
    }

# For testing purposes:
if __name__ == "__main__":
    event = {"source-document": "app_table.xlsx"}
    print(lambda_handler(event, None))
