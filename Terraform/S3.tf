

resource "aws_s3_bucket" "eks_s3_bucket" {
  bucket = "my-eks-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "eks-s3-bucket"
    Environment = "Production"
  }
}
