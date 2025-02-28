

variable "volume_size" {
  description = "The size of the EBS volume in GiB"
  type        = number
  default     = 20  
}

variable "volume_type" {
  description = "The type of the EBS volume (gp2, io1, etc.)"
  type        = string
  default     = "io1"  
}

variable "availability_zone" {
  description = "The availability zone for the EBS volume"
  type        = string
  default     = "us-west-2a"  
}
