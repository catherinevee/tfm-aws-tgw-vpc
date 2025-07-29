# Basic Example Outputs
# This file demonstrates how to use the outputs from the advanced networking module

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.basic_networking.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.basic_networking.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.basic_networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.basic_networking.private_subnet_ids
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = module.basic_networking.database_subnet_ids
}

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = module.basic_networking.transit_gateway_id
}

output "default_security_group_id" {
  description = "The ID of the default security group"
  value       = module.basic_networking.default_security_group_id
}

output "custom_security_group_ids" {
  description = "Map of custom security group IDs"
  value       = module.basic_networking.custom_security_group_ids
}

output "vpc_endpoint_s3_id" {
  description = "The ID of the S3 VPC endpoint"
  value       = module.basic_networking.vpc_endpoint_s3_id
}

output "vpc_summary" {
  description = "Summary of VPC resources created"
  value       = module.basic_networking.vpc_summary
}

output "transit_gateway_summary" {
  description = "Summary of Transit Gateway resources created"
  value       = module.basic_networking.transit_gateway_summary
} 