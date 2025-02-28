
provider "aws" {
  region = "us-west-2"  
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "eks-vpc"
  cidr = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  public_subnets  = ["34.0.0.0/8", "8.0.0.0/8", "128.0.0.0/8"]

  
  enable_nat_gateway = true
}


resource "aws_security_group" "eks_sg" {
  name        = "eks-worker-sg"
  description = "Allow SSH and Kubernetes traffic to EKS worker nodes"
  vpc_id      = module.vpc.vpc_id

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Kubernetes API access"
  }

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [203.0.113.5/32]  
    description = "Allow SSH access"
  }

  
}


resource "aws_security_group" "alb_sg" {
  name        = "eks-alb-sg"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }

  
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  
  }
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "OTP-cluster"
  cluster_version = "1.21"  
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      key_name         = "ssh-key"  
      additional_security_group_ids = [aws_security_group.eks_sg.id]
    }
  }

  
  node_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eksNodeRole"
}


resource "aws_lb" "eks_alb" {
  name               = "eks-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.eks_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "OK"
    }
  }
}


resource "aws_autoscaling_group" "eks_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = module.vpc.private_subnets
  launch_configuration = aws_launch_configuration.eks_launch_configuration.id
  health_check_type    = "EC2"
  health_check_grace_period = 300
}


resource "aws_launch_configuration" "eks_launch_configuration" {
  name_prefix   = "eks-worker-"
  image_id      = data.aws_ami.eks_worker_image.id
  instance_type = "t3.medium"
  key_name      = "my-keypair"
  security_groups = [aws_security_group.eks_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}


data "aws_caller_identity" "current" {}


data "aws_ami" "eks_worker_image" {
  most_recent = true
  owners      = ["602401143452"]  
  filters = {
    name = "amzn2-ami-k8s-1.21*"
  }
}
