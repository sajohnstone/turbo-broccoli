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
  tags = {
    name = "role for device reading lambda"
    "env:stack" = terraform.workspace
    "env:project" = "turbo-broccoli"
    "costcenter" = "home"
    "owner:contact" = "sajohnstone@yahoo.co.uk"
  }
}

# Attach policy
resource "aws_iam_role_policy_attachment" "aws-managed-policy-attachment" {
  role = aws_iam_role.role_for_get_device_reading.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

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
  tags = {
    name = "device reading lambda"
    "env:stack" = terraform.workspace
    "env:project" = "turbo-broccoli"
    "costcenter" = "home"
    "owner:contact" = "sajohnstone@yahoo.co.uk"
  }
}

# API Gateway

resource "aws_api_gateway_rest_api" "api" {
 name = "device-api-gateway"
 description = "Proxy to handle requests to the device API"
tags = {
  name = "API for device reading lambda"
  "env:stack" = terraform.workspace
  "env:project" = "turbo-broccoli"
  "costcenter" = "home"
  "owner:contact" = "sajohnstone@yahoo.co.uk"
}
}

resource "aws_api_gateway_resource" "devices" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "device"
}

resource "aws_api_gateway_resource" "deviceid" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.devices.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get-method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.deviceid.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.deviceid.id
  http_method = aws_api_gateway_method.get-method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"  //LAMBDA
  uri                     = aws_lambda_function.get_device_reading.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_device_reading.function_name
  principal     = "apigateway.amazonaws.com"
}

output "endpoint" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.us-east-1.amazonaws.com"
}