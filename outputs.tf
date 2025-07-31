# =============================================================================
# VPC Outputs
# =============================================================================

output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.create_vpc ? aws_vpc.main[0].id : null
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = var.create_vpc ? aws_vpc.main[0].arn : null
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = var.create_vpc ? aws_vpc.main[0].cidr_block : null
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = var.create_vpc ? aws_vpc.main[0].ipv6_cidr_block : null
}

output "vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = var.create_vpc ? aws_vpc.main[0].default_security_group_id : null
}

output "vpc_default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = var.create_vpc ? aws_vpc.main[0].default_network_acl_id : null
}

output "vpc_default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = var.create_vpc ? aws_vpc.main[0].default_route_table_id : null
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = var.create_vpc ? aws_vpc.main[0].main_route_table_id : null
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = var.create_vpc ? aws_vpc.main[0].owner_id : null
}

# =============================================================================
# Internet Gateway Outputs
# =============================================================================

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = var.create_vpc && var.create_igw ? aws_internet_gateway.main[0].id : null
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = var.create_vpc && var.create_igw ? aws_internet_gateway.main[0].arn : null
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the Egress Only Internet Gateway"
  value       = var.create_vpc && var.enable_ipv6 && var.create_egress_only_igw ? aws_egress_only_internet_gateway.main[0].id : null
}

# =============================================================================
# Subnet Outputs
# =============================================================================

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = var.create_vpc ? aws_subnet.public[*].id : []
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = var.create_vpc ? aws_subnet.public[*].arn : []
}

output "public_subnet_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = var.create_vpc ? aws_subnet.public[*].cidr_block : []
}

output "public_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets"
  value       = var.create_vpc ? aws_subnet.public[*].ipv6_cidr_block : []
}

output "public_subnet_availability_zones" {
  description = "List of availability zones of public subnets"
  value       = var.create_vpc ? aws_subnet.public[*].availability_zone : []
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = var.create_vpc ? aws_subnet.private[*].id : []
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = var.create_vpc ? aws_subnet.private[*].arn : []
}

output "private_subnet_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = var.create_vpc ? aws_subnet.private[*].cidr_block : []
}

output "private_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets"
  value       = var.create_vpc ? aws_subnet.private[*].ipv6_cidr_block : []
}

output "private_subnet_availability_zones" {
  description = "List of availability zones of private subnets"
  value       = var.create_vpc ? aws_subnet.private[*].availability_zone : []
}

output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_subnet.database[*].id : []
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_subnet.database[*].arn : []
}

output "database_subnet_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_subnet.database[*].cidr_block : []
}

output "database_subnet_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_subnet.database[*].ipv6_cidr_block : []
}

output "database_subnet_availability_zones" {
  description = "List of availability zones of database subnets"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_subnet.database[*].availability_zone : []
}

# =============================================================================
# NAT Gateway Outputs
# =============================================================================

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_nat_gateway.main[*].id : []
}

output "nat_gateway_arns" {
  description = "List of NAT Gateway ARNs"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_nat_gateway.main[*].arn : []
}

output "nat_gateway_public_ips" {
  description = "List of public IP addresses of NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_nat_gateway.main[*].public_ip : []
}

output "nat_gateway_private_ips" {
  description = "List of private IP addresses of NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_nat_gateway.main[*].private_ip : []
}

output "nat_gateway_connectivity_types" {
  description = "List of connectivity types of NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_nat_gateway.main[*].connectivity_type : []
}

output "nat_eip_ids" {
  description = "List of Elastic IP IDs for NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_eip.nat[*].id : []
}

output "nat_eip_public_ips" {
  description = "List of Elastic IP public IPs for NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_eip.nat[*].public_ip : []
}

output "nat_eip_allocation_ids" {
  description = "List of Elastic IP allocation IDs for NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_eip.nat[*].allocation_id : []
}

output "nat_eip_network_border_groups" {
  description = "List of Elastic IP network border groups for NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_eip.nat[*].network_border_group : []
}

output "nat_eip_carrier_ips" {
  description = "List of Elastic IP carrier IPs for NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_eip.nat[*].carrier_ip : []
}

output "nat_eip_customer_owned_ips" {
  description = "List of Elastic IP customer owned IPs for NAT Gateways"
  value       = var.create_vpc && var.enable_nat_gateway ? aws_eip.nat[*].customer_owned_ip : []
}

# =============================================================================
# Route Table Outputs
# =============================================================================

output "public_route_table_id" {
  description = "ID of public route table"
  value       = var.create_vpc ? aws_route_table.public[0].id : null
}

output "public_route_table_arn" {
  description = "ARN of public route table"
  value       = var.create_vpc ? aws_route_table.public[0].arn : null
}

output "public_route_table_owner_id" {
  description = "Owner ID of public route table"
  value       = var.create_vpc ? aws_route_table.public[0].owner_id : null
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = var.create_vpc ? aws_route_table.private[*].id : []
}

output "private_route_table_arns" {
  description = "List of ARNs of private route tables"
  value       = var.create_vpc ? aws_route_table.private[*].arn : []
}

output "private_route_table_owner_ids" {
  description = "List of owner IDs of private route tables"
  value       = var.create_vpc ? aws_route_table.private[*].owner_id : []
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_route_table.database[*].id : []
}

output "database_route_table_arns" {
  description = "List of ARNs of database route tables"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_route_table.database[*].arn : []
}

output "database_route_table_owner_ids" {
  description = "List of owner IDs of database route tables"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? aws_route_table.database[*].owner_id : []
}

output "public_additional_route_ids" {
  description = "List of IDs of additional public routes"
  value       = var.create_vpc ? [for route in aws_route.public_additional : route.id] : []
}

output "private_additional_route_ids" {
  description = "List of IDs of additional private routes"
  value       = var.create_vpc ? [for route in aws_route.private_additional : route.id] : []
}

output "database_additional_route_ids" {
  description = "List of IDs of additional database routes"
  value       = var.create_vpc && length(var.database_subnets) > 0 ? [for route in aws_route.database_additional : route.id] : []
}

# =============================================================================
# Transit Gateway Outputs
# =============================================================================

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].id : null
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].arn : null
}

output "transit_gateway_owner_id" {
  description = "The ID of the AWS account that owns the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].owner_id : null
}

output "transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].association_default_route_table_id : null
}

output "transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].propagation_default_route_table_id : null
}

output "transit_gateway_route_table_ids" {
  description = "List of Transit Gateway route table IDs"
  value       = var.create_transit_gateway && var.create_tgw_route_tables ? aws_ec2_transit_gateway_route_table.main[*].id : []
}

output "transit_gateway_route_table_arns" {
  description = "List of Transit Gateway route table ARNs"
  value       = var.create_transit_gateway && var.create_tgw_route_tables ? aws_ec2_transit_gateway_route_table.main[*].arn : []
}

output "transit_gateway_vpc_attachment_id" {
  description = "The ID of the Transit Gateway VPC attachment"
  value       = var.create_transit_gateway && var.create_vpc ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : null
}

output "transit_gateway_vpc_attachment_arn" {
  description = "The ARN of the Transit Gateway VPC attachment"
  value       = var.create_transit_gateway && var.create_vpc ? aws_ec2_transit_gateway_vpc_attachment.main[0].arn : null
}

# =============================================================================
# Security Group Outputs
# =============================================================================

output "default_security_group_id" {
  description = "The ID of the default security group"
  value       = var.create_vpc && var.create_default_security_group ? aws_security_group.default[0].id : null
}

output "default_security_group_arn" {
  description = "The ARN of the default security group"
  value       = var.create_vpc && var.create_default_security_group ? aws_security_group.default[0].arn : null
}

output "default_security_group_name" {
  description = "The name of the default security group"
  value       = var.create_vpc && var.create_default_security_group ? aws_security_group.default[0].name : null
}

output "custom_security_group_ids" {
  description = "Map of custom security group IDs"
  value       = var.create_vpc ? { for k, v in aws_security_group.custom : k => v.id } : {}
}

output "custom_security_group_arns" {
  description = "Map of custom security group ARNs"
  value       = var.create_vpc ? { for k, v in aws_security_group.custom : k => v.arn } : {}
}

output "custom_security_group_names" {
  description = "Map of custom security group names"
  value       = var.create_vpc ? { for k, v in aws_security_group.custom : k => v.name } : {}
}

# =============================================================================
# VPC Endpoint Outputs
# =============================================================================

output "vpc_endpoint_s3_id" {
  description = "The ID of the S3 VPC endpoint"
  value       = var.create_vpc && var.create_vpc_endpoints.s3 ? aws_vpc_endpoint.s3[0].id : null
}

output "vpc_endpoint_s3_arn" {
  description = "The ARN of the S3 VPC endpoint"
  value       = var.create_vpc && var.create_vpc_endpoints.s3 ? aws_vpc_endpoint.s3[0].arn : null
}

output "vpc_endpoint_dynamodb_id" {
  description = "The ID of the DynamoDB VPC endpoint"
  value       = var.create_vpc && var.create_vpc_endpoints.dynamodb ? aws_vpc_endpoint.dynamodb[0].id : null
}

output "vpc_endpoint_dynamodb_arn" {
  description = "The ARN of the DynamoDB VPC endpoint"
  value       = var.create_vpc && var.create_vpc_endpoints.dynamodb ? aws_vpc_endpoint.dynamodb[0].arn : null
}

output "vpc_endpoint_interface_ids" {
  description = "Map of interface VPC endpoint IDs"
  value       = var.create_vpc ? { for k, v in aws_vpc_endpoint.interface : k => v.id } : {}
}

output "vpc_endpoint_interface_arns" {
  description = "Map of interface VPC endpoint ARNs"
  value       = var.create_vpc ? { for k, v in aws_vpc_endpoint.interface : k => v.arn } : {}
}

# =============================================================================
# Data Source Outputs
# =============================================================================

output "region" {
  description = "The current AWS region"
  value       = data.aws_region.current.name
}

output "availability_zones" {
  description = "List of available availability zones"
  value       = data.aws_availability_zones.available.names
}

# =============================================================================
# Summary Outputs
# =============================================================================

output "vpc_summary" {
  description = "Summary of VPC resources created"
  value = var.create_vpc ? {
    vpc_id                    = aws_vpc.main[0].id
    vpc_cidr                  = aws_vpc.main[0].cidr_block
    public_subnet_count       = length(aws_subnet.public)
    private_subnet_count      = length(aws_subnet.private)
    database_subnet_count     = length(aws_subnet.database)
    nat_gateway_count         = var.enable_nat_gateway ? length(aws_nat_gateway.main) : 0
    security_group_count      = var.create_default_security_group ? 1 : 0 + length(var.custom_security_groups)
    vpc_endpoint_count        = (var.create_vpc_endpoints.s3 ? 1 : 0) + (var.create_vpc_endpoints.dynamodb ? 1 : 0) + length(var.interface_vpc_endpoints)
  } : null
}

output "transit_gateway_summary" {
  description = "Summary of Transit Gateway resources created"
  value = var.create_transit_gateway ? {
    transit_gateway_id           = aws_ec2_transit_gateway.main[0].id
    route_table_count           = var.create_tgw_route_tables ? length(aws_ec2_transit_gateway_route_table.main) : 0
    vpc_attachment_count        = var.create_vpc ? 1 : 0
  } : null
}

# =============================================================================
# Network ACL Outputs
# =============================================================================

output "public_network_acl_id" {
  description = "The ID of the public Network ACL"
  value       = var.create_vpc && var.create_network_acls ? aws_network_acl.public[0].id : null
}

output "public_network_acl_arn" {
  description = "The ARN of the public Network ACL"
  value       = var.create_vpc && var.create_network_acls ? aws_network_acl.public[0].arn : null
}

output "private_network_acl_id" {
  description = "The ID of the private Network ACL"
  value       = var.create_vpc && var.create_network_acls ? aws_network_acl.private[0].id : null
}

output "private_network_acl_arn" {
  description = "The ARN of the private Network ACL"
  value       = var.create_vpc && var.create_network_acls ? aws_network_acl.private[0].arn : null
}

# =============================================================================
# DHCP Options Outputs
# =============================================================================

output "dhcp_options_id" {
  description = "The ID of the DHCP Options"
  value       = var.create_vpc && var.create_dhcp_options ? aws_vpc_dhcp_options.main[0].id : null
}

output "dhcp_options_arn" {
  description = "The ARN of the DHCP Options"
  value       = var.create_vpc && var.create_dhcp_options ? aws_vpc_dhcp_options.main[0].arn : null
}

# =============================================================================
# Flow Logs Outputs
# =============================================================================

output "flow_log_id" {
  description = "The ID of the VPC Flow Log"
  value       = var.create_vpc && var.create_flow_logs ? aws_flow_log.main[0].id : null
}

output "flow_log_arn" {
  description = "The ARN of the VPC Flow Log"
  value       = var.create_vpc && var.create_flow_logs ? aws_flow_log.main[0].arn : null
}

output "flow_log_cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for Flow Logs"
  value       = var.create_vpc && var.create_flow_logs && var.flow_log_destination_type == "cloud-watch-logs" ? aws_cloudwatch_log_group.flow_logs[0].arn : null
}

output "flow_log_iam_role_arn" {
  description = "The ARN of the IAM Role for Flow Logs"
  value       = var.create_vpc && var.create_flow_logs ? aws_iam_role.flow_logs[0].arn : null
} 