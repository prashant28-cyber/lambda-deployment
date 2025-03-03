import boto3
import pymysql
import json

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = 'your-s3-bucket'
    file_key = 'data.json'
    rds_host = 'your-rds-endpoint'
    database = 'your-db'
    username = 'your-user'
    password = 'your-password'
    glue_database = 'your-glue-db'

    try:
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        data = json.loads(response['Body'].read())
        conn = pymysql.connect(host=rds_host, user=username, password=password, database=database)
        cursor = conn.cursor()
        query = "INSERT INTO your_table (column1, column2) VALUES (%s, %s)"
        for item in data:
            cursor.execute(query, (item['column1'], item['column2']))
        conn.commit()
        return {"status": "Success", "message": "Data inserted into RDS"}
    except Exception as e:
        glue = boto3.client('glue')
        glue.start_job_run(JobName='your-glue-job')
        return {"status": "Failed", "message": str(e), "fallback": "Glue triggered"}
