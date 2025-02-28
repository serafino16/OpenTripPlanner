

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "s3_bucket_name" {
  value = aws_s3_bucket.eks_s3_bucket.bucket
}

output "ecr_repository_url" {
  value = aws_ecr_repository.my_ecr.repository_url
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.my_distribution.id
}


output "ebs_volume_id" {
  value = aws_ebs_volume.db_volume.id
}

output "ebs_volume_arn" {
  value = aws_ebs_volume.db_volume.arn
}

output "ebs_volume_size" {
  value = aws_ebs_volume.db_volume.size
}

output "ebs_volume_type" {
  value = aws_ebs_volume.db_volume.volume_type
}

