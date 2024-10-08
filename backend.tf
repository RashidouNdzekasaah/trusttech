terraform {
  backend "s3" {
    bucket = "webapps-buck"    # Replace with your S3 bucket name
    key    = "terraform/state" # Path within the bucket
    region = "us-east-1"       # Change to your desired region
  }
}