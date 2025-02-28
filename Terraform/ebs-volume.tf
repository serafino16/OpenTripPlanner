
resource "aws_ebs_volume" "db_volume" {
  availability_zone = var.availability_zone  
  size              = var.volume_size       
  volume_type       = var.volume_type       
  tags = {
    Name = "DynamicDBVolume"  
  }
}





