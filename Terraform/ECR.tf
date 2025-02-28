

resource "aws_ecr_repository" "my_ecr" {
  name                 = "eks-repository"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name        = "eks-repository"
    Environment = "Production"
  }
}
