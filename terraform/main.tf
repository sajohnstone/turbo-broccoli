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
resource "aws_iam_role" "role_for_get_device_reading" {
  name = "iam_for_device_reading_lambda"
  assume_role_policy = <<-EOF
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

# Attach policy
resource "aws_iam_role_policy_attachment" "aws-managed-policy-attachment" {
  role = "${aws_iam_role.role_for_get_device_reading.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


/*
# Created Policy for IAM Role
resource "aws_iam_policy" "policy_for_get_device_reading" {
  name = "policy_for_device_reading_lambda"
  description = "Policy so device can read from S3"
  policy = <<-EOF
    {
      "Version":"2012-10-17",
      "Statement":[
          {
            "Effect":"Allow",
            "Action":[
                "logs:*"
            ],
            "Resource":"arn:aws:logs:*:*:*"
          },
          {
            "Effect":"Allow",
            "Action":[
                "s3:*"
            ],
            "Resource":"${aws_s3_bucket.csv_store.arn}"
          }
      ]
    }
  EOF
}

# Attach policy
resource "aws_iam_role_policy_attachment" "attachment_for_get_device_reading" {
  role       = "${aws_iam_role.role_for_get_device_reading.name}"
  policy_arn = "${aws_iam_policy.policy_for_get_device_reading.arn}"
}
*/

# ZIP for lambda
data "archive_file" "get_device_reading_archive" {
  type        = "zip"
  source_dir   = "./../lambda/get_device_reading/dist"
  output_path = "./../dist/get_device_reading.zip"
}

# GET device reading lambda
resource "aws_lambda_function" "get_device_reading" {
  filename          = data.archive_file.get_device_reading_archive.output_path
  function_name     = "get_device_reading"
  role              = aws_iam_role.role_for_get_device_reading.arn
  handler           = "index.handler"
  source_code_hash  = filebase64sha256(data.archive_file.get_device_reading_archive.output_path)
  runtime           = "nodejs14.x"
}