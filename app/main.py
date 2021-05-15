#!/usr/bin/python

import boto3, os
from time import sleep, time

def ls_bucket(bucket_name):
  response = s3.list_objects(Bucket=bucket_name)
  if "Contents" in response.keys():
    return [object["Key"] for object in response["Contents"]]
  else:
    return []

def main(bucket_name, sleep_seconds):
  i = 0
  while True:
    i += 1
    print(f"\n### Iteration {i} ###")
    object_key = f"demofile{i}.txt"
    object_body = f"written at {str(round(time()))}"

    # upload
    print(f"Uploading object '{bucket_name}/{object_key}'...", end = "")
    print(f"{s3.put_object(Bucket=bucket_name, Key=object_key, Body=object_body)['ResponseMetadata']['HTTPStatusCode']}")
    print(f"Bucket '{bucket_name}' contents: {ls_bucket(bucket_name)}")

    # sleep
    print(f"Sleeping for {sleep_seconds} seconds...")
    sleep(sleep_seconds)

    # remove
    print(f"Removing object '{bucket_name}/{object_key}'...", end = "")
    print(f"{s3.delete_object(Bucket=bucket_name, Key=object_key)['ResponseMetadata']['HTTPStatusCode']}")
    print(f"Bucket '{bucket_name}' contents: {ls_bucket(bucket_name)}")

if __name__ == "__main__":
  try:
    bucket_name = os.environ["BUCKET_NAME"]
  except KeyError:
    print("ERROR: Environment variable BUCKET_NAME doesn't exist!")
    exit(1)

  try:
    s3 = boto3.client("s3")
  except boto3.exceptions.botocore.exceptions.ProfileNotFound as e:
    print(f"ERROR: {e}")
    exit(1)

  try:
    s3.head_bucket(Bucket=bucket_name)["ResponseMetadata"]["HTTPStatusCode"]
  except boto3.exceptions.botocore.exceptions.ClientError as e:
    print(f"ERROR: For bucket '{bucket_name}': {e}")
    exit(1)

  try:
    sleep_seconds = os.environ["SLEEP_SECONDS_OVERRIDE"]
  except KeyError:
    sleep_seconds = 8

  print(f"bucket_name = {bucket_name}")
  print(f"sleep_seconds = {sleep_seconds}")

  main(bucket_name, sleep_seconds)
