provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-bucket"
}

resource "aws_rds_cluster" "example" {
  cluster_identifier = "my-rds-cluster"
  engine            = "aurora-postgresql"
  master_username   = var.db_user
  master_password   = var.db_password
}

resource "aws_ecr_repository" "lambda_repo" {
  name = "lambda-container-repo"
}

resource "aws_lambda_function" "example" {
  function_name = "LambdaFromECR"
  role          = aws_iam_role.lambda_exec.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repo.repository_url}:latest"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
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


