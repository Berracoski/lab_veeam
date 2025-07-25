## Bucket repositorio
resource "aws_s3_bucket" "at_laboratorio_repo" {
  bucket = "at-laboratorio-repo"
}

## Bucket laboratorio encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "at_laboratorio_encryption" {
  bucket = aws_s3_bucket.at_laboratorio_repo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}