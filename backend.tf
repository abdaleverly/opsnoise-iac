terraform {
  backend "s3" {
      bucket = "opsnoise-iac"
      key = "base"
      region = "us-east-1"
  }
}