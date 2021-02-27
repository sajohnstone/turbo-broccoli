# S3 bucket
resource "aws_s3_bucket" "csv_store" {
  bucket = "csv-store-${terraform.workspace}"
  force_destroy = true
  tags = {
    name = "S3 bucket csv-store"
    "env:stack" = terraform.workspace
    "env:project" = "turbo-broccoli"
    "costcenter" = "home"
    "owner:contact" = "sajohnstone@yahoo.co.uk"
  }
}

# Timesheet.csv upload to S3
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.csv_store.id
  key    = "timezone"
  acl    = "private" 
  source = "./../resources/timezone.csv"
}

# IAM for GET Device Reading
resource "aws_iam_role" "iam_for_get_device_reading" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# ZIP for lambda
data "archive_file" "get_device_reading_archive" {
  type        = "zip"
  source_file = "./../lambda/get_device_reading/index.js"
  output_path = "./../dist/get_device_reading.zip"
}

# GET device reading lambda
resource "aws_lambda_function" "get_device_reading" {
  filename          = data.archive_file.get_device_reading_archive.output_path
  function_name     = "get_device_reading"
  role              = aws_iam_role.iam_for_get_device_reading.arn
  handler           = "index.handler"
  source_code_hash  = filebase64sha256(data.archive_file.get_device_reading_archive.output_path)
  runtime           = "nodejs14.x"
}