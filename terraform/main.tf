resource "aws_s3_bucket" "csv_store" {
  bucket = "csv-store-${terraform.workspace}"
  force_destroy = true
  tags = {
    name = "S3 bucket (csv-store)"
    "env:stack" = terraform.workspace
    "env:project" = "turbo-broccoli"
    "owner:costcenter" = "test"
    "owner:contact" = "sajohnstone@yahoo.co.uk"
  }
}