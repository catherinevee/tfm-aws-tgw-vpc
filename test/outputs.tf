# Test Outputs
# This file validates the outputs from the advanced networking module

output "test_vpc_id" {
  description = "Test VPC ID"
  value       = module.test_networking.vpc_id
}

output "test_vpc_cidr_block" {
  description = "Test VPC CIDR block"
  value       = module.test_networking.vpc_cidr_block
}

output "test_public_subnet_ids" {
  description = "Test public subnet IDs"
  value       = module.test_networking.public_subnet_ids
}

output "test_private_subnet_ids" {
  description = "Test private subnet IDs"
  value       = module.test_networking.private_subnet_ids
}

output "test_transit_gateway_id" {
  description = "Test Transit Gateway ID"
  value       = module.test_networking.transit_gateway_id
}

output "test_default_security_group_id" {
  description = "Test default security group ID"
  value       = module.test_networking.default_security_group_id
}

output "test_custom_security_group_ids" {
  description = "Test custom security group IDs"
  value       = module.test_networking.custom_security_group_ids
}

output "test_vpc_endpoint_s3_id" {
  description = "Test S3 VPC endpoint ID"
  value       = module.test_networking.vpc_endpoint_s3_id
}

output "test_vpc_summary" {
  description = "Test VPC summary"
  value       = module.test_networking.vpc_summary
}

output "test_transit_gateway_summary" {
  description = "Test Transit Gateway summary"
  value       = module.test_networking.transit_gateway_summary
} 