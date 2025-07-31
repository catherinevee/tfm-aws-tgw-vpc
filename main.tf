# Advanced AWS Networking Module
# Combines VPC, Transit Gateway, and Security Groups for comprehensive networking

# =============================================================================
# VPC Configuration
# =============================================================================

# Main VPC
resource "aws_vpc" "main" {
  count = var.create_vpc ? 1 : 0

  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = var.instance_tenancy
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  ipv4_ipam_pool_id                   = var.ipv4_ipam_pool_id
  ipv4_netmask_length                 = var.ipv4_netmask_length
  ipv6_cidr_block                     = var.ipv6_cidr_block
  ipv6_ipam_pool_id                   = var.ipv6_ipam_pool_id
  ipv6_netmask_length                 = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.vpc_tags,
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  count = var.create_vpc && var.create_igw ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    {
      Name = "${var.vpc_name}-igw"
    },
    var.internet_gateway_tags,
    var.tags
  )
}

# Egress Only Internet Gateway for IPv6
resource "aws_egress_only_internet_gateway" "main" {
  count = var.create_vpc && var.enable_ipv6 && var.create_egress_only_igw ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    {
      Name = "${var.vpc_name}-eigw"
    },
    var.egress_only_internet_gateway_tags,
    var.tags
  )
}

# =============================================================================
# Subnet Configuration
# =============================================================================

# Public Subnets
resource "aws_subnet" "public" {
  count = var.create_vpc ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  map_customer_owned_ip_on_launch = var.map_customer_owned_ip_on_launch
  customer_owned_ipv4_pool = var.customer_owned_ipv4_pool
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch

  # IPv6 configuration
  ipv6_cidr_block                 = var.enable_ipv6 ? var.public_subnet_ipv6_cidrs[count.index] : null
  assign_ipv6_address_on_creation = var.enable_ipv6

  tags = merge(
    {
      Name = "${var.vpc_name}-public-${var.availability_zones[count.index]}"
      Tier = "Public"
    },
    var.public_subnet_tags,
    var.tags
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = var.create_vpc ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_customer_owned_ip_on_launch = var.map_customer_owned_ip_on_launch
  customer_owned_ipv4_pool = var.customer_owned_ipv4_pool
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch

  # IPv6 configuration
  ipv6_cidr_block                 = var.enable_ipv6 ? var.private_subnet_ipv6_cidrs[count.index] : null
  assign_ipv6_address_on_creation = var.enable_ipv6

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${var.availability_zones[count.index]}"
      Tier = "Private"
    },
    var.private_subnet_tags,
    var.tags
  )
}

# Database Subnets
resource "aws_subnet" "database" {
  count = var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_customer_owned_ip_on_launch = var.map_customer_owned_ip_on_launch
  customer_owned_ipv4_pool = var.customer_owned_ipv4_pool
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch

  # IPv6 configuration
  ipv6_cidr_block                 = var.enable_ipv6 ? var.database_subnet_ipv6_cidrs[count.index] : null
  assign_ipv6_address_on_creation = var.enable_ipv6

  tags = merge(
    {
      Name = "${var.vpc_name}-database-${var.availability_zones[count.index]}"
      Tier = "Database"
    },
    var.database_subnet_tags,
    var.tags
  )
}

# =============================================================================
# NAT Gateway Configuration
# =============================================================================

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = var.create_vpc && var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnets)) : 0

  domain = "vpc"
  address = lookup(var.nat_eip_configuration, "address", null)
  network_border_group = lookup(var.nat_eip_configuration, "network_border_group", null)
  public_ipv4_pool = lookup(var.nat_eip_configuration, "public_ipv4_pool", null)
  carrier_ip = lookup(var.nat_eip_configuration, "carrier_ip", null)
  customer_owned_ipv4_pool = lookup(var.nat_eip_configuration, "customer_owned_ipv4_pool", null)
  instance = lookup(var.nat_eip_configuration, "instance", null)
  network_interface = lookup(var.nat_eip_configuration, "network_interface", null)
  associate_with_private_ip = lookup(var.nat_eip_configuration, "associate_with_private_ip", null)
  vpc = lookup(var.nat_eip_configuration, "vpc", true)

  tags = merge(
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    },
    var.eip_tags,
    var.tags
  )

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  count = var.create_vpc && var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnets)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[var.single_nat_gateway ? 0 : count.index].id
  connectivity_type = lookup(var.nat_gateway_configuration, "connectivity_type", "public")
  private_ip = lookup(var.nat_gateway_configuration, "private_ip", null)
  secondary_allocation_ids = lookup(var.nat_gateway_configuration, "secondary_allocation_ids", null)
  secondary_private_ip_addresses = lookup(var.nat_gateway_configuration, "secondary_private_ip_addresses", null)
  secondary_private_ip_address_count = lookup(var.nat_gateway_configuration, "secondary_private_ip_address_count", null)

  tags = merge(
    {
      Name = "${var.vpc_name}-nat-${count.index + 1}"
    },
    var.nat_gateway_tags,
    var.tags
  )

  depends_on = [aws_internet_gateway.main]
}

# =============================================================================
# Route Tables Configuration
# =============================================================================

# Public Route Table
resource "aws_route_table" "public" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    {
      Name = "${var.vpc_name}-public-rt"
    },
    var.route_table_tags,
    var.tags
  )
}

# Public Routes
resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && var.create_igw ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main[0].id
}

resource "aws_route" "public_internet_gateway_ipv6" {
  count = var.create_vpc && var.create_igw && var.enable_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.public[0].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.main[0].id
}

# Additional Public Routes
resource "aws_route" "public_additional" {
  for_each = var.create_vpc ? { for i, route in var.public_route_table_routes : i => route } : {}

  route_table_id = aws_route_table.public[0].id
  
  destination_cidr_block = lookup(each.value, "cidr_block", null)
  destination_ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  destination_prefix_list_id = lookup(each.value, "destination_prefix_list_id", null)
  gateway_id                = lookup(each.value, "gateway_id", null)
  nat_gateway_id            = lookup(each.value, "nat_gateway_id", null)
  network_interface_id      = lookup(each.value, "network_interface_id", null)
  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
  egress_only_gateway_id    = lookup(each.value, "egress_only_gateway_id", null)
  core_network_arn          = lookup(each.value, "core_network_arn", null)
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count = var.create_vpc ? length(var.public_subnets) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = var.create_vpc ? length(var.private_subnets) : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    {
      Name = "${var.vpc_name}-private-rt-${var.availability_zones[count.index]}"
    },
    var.route_table_tags,
    var.tags
  )
}

# Private Routes
resource "aws_route" "private_nat_gateway" {
  count = var.create_vpc && var.enable_nat_gateway ? length(var.private_subnets) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[var.single_nat_gateway ? 0 : count.index].id
}

resource "aws_route" "private_egress_only_internet_gateway" {
  count = var.create_vpc && var.enable_ipv6 && var.create_egress_only_igw ? length(var.private_subnets) : 0

  route_table_id              = aws_route_table.private[count.index].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.main[0].id
}

# Additional Private Routes
resource "aws_route" "private_additional" {
  for_each = var.create_vpc ? { for i, route in var.private_route_table_routes : i => route } : {}

  route_table_id = aws_route_table.private[each.value.az_index != null ? each.value.az_index : 0].id
  
  destination_cidr_block = lookup(each.value, "cidr_block", null)
  destination_ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  destination_prefix_list_id = lookup(each.value, "destination_prefix_list_id", null)
  gateway_id                = lookup(each.value, "gateway_id", null)
  nat_gateway_id            = lookup(each.value, "nat_gateway_id", null)
  network_interface_id      = lookup(each.value, "network_interface_id", null)
  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
  egress_only_gateway_id    = lookup(each.value, "egress_only_gateway_id", null)
  core_network_arn          = lookup(each.value, "core_network_arn", null)
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count = var.create_vpc ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Database Route Tables
resource "aws_route_table" "database" {
  count = var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    {
      Name = "${var.vpc_name}-database-rt-${var.availability_zones[count.index]}"
    },
    var.route_table_tags,
    var.tags
  )
}

# Database Routes
resource "aws_route" "database_nat_gateway" {
  count = var.create_vpc && var.enable_nat_gateway && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  route_table_id         = aws_route_table.database[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[var.single_nat_gateway ? 0 : count.index].id
}

# Additional Database Routes
resource "aws_route" "database_additional" {
  for_each = var.create_vpc && length(var.database_subnets) > 0 ? { for i, route in var.database_route_table_routes : i => route } : {}

  route_table_id = aws_route_table.database[each.value.az_index != null ? each.value.az_index : 0].id
  
  destination_cidr_block = lookup(each.value, "cidr_block", null)
  destination_ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  destination_prefix_list_id = lookup(each.value, "destination_prefix_list_id", null)
  gateway_id                = lookup(each.value, "gateway_id", null)
  nat_gateway_id            = lookup(each.value, "nat_gateway_id", null)
  network_interface_id      = lookup(each.value, "network_interface_id", null)
  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
  egress_only_gateway_id    = lookup(each.value, "egress_only_gateway_id", null)
  core_network_arn          = lookup(each.value, "core_network_arn", null)
}

# Database Route Table Associations
resource "aws_route_table_association" "database" {
  count = var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}

# =============================================================================
# Transit Gateway Configuration
# =============================================================================

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  count = var.create_transit_gateway ? 1 : 0

  description                     = var.tgw_description
  amazon_side_asn                 = var.tgw_amazon_side_asn
  auto_accept_shared_attachments  = var.tgw_auto_accept_shared_attachments
  default_route_table_association = var.tgw_default_route_table_association
  default_route_table_propagation = var.tgw_default_route_table_propagation
  dns_support                     = var.tgw_dns_support
  multicast_support               = var.tgw_multicast_support
  transit_gateway_cidr_blocks     = var.tgw_cidr_blocks
  vpn_ecmp_support                = var.tgw_vpn_ecmp_support

  tags = merge(
    {
      Name = var.tgw_name
    },
    var.tgw_tags,
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Transit Gateway Route Tables
resource "aws_ec2_transit_gateway_route_table" "main" {
  count = var.create_transit_gateway && var.create_tgw_route_tables ? length(var.tgw_route_tables) : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  
  tags = merge(
    {
      Name = var.tgw_route_tables[count.index].name
    },
    var.tgw_route_tables[count.index].tags,
    var.tags
  )
}

# Transit Gateway VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.create_transit_gateway && var.create_vpc ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  vpc_id             = aws_vpc.main[0].id
  subnet_ids         = aws_subnet.private[*].id

  appliance_mode_support                          = var.tgw_vpc_attachment.appliance_mode_support
  dns_support                                     = var.tgw_vpc_attachment.dns_support
  ipv6_support                                    = var.tgw_vpc_attachment.ipv6_support
  transit_gateway_default_route_table_association = var.tgw_vpc_attachment.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.tgw_vpc_attachment.transit_gateway_default_route_table_propagation

  tags = merge(
    {
      Name = "${var.vpc_name}-tgw-attachment"
    },
    var.tags
  )
}

# =============================================================================
# Security Groups Configuration
# =============================================================================

# Default Security Group
resource "aws_security_group" "default" {
  count = var.create_vpc && var.create_default_security_group ? 1 : 0

  name_prefix = "${var.vpc_name}-default-sg-"
  vpc_id      = aws_vpc.main[0].id
  description = "Default security group for ${var.vpc_name} VPC"

  dynamic "ingress" {
    for_each = var.default_security_group_ingress_rules
    content {
      description        = ingress.value.description
      from_port          = ingress.value.from_port
      to_port            = ingress.value.to_port
      protocol           = ingress.value.protocol
      cidr_blocks        = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks   = lookup(ingress.value, "ipv6_cidr_blocks", null)
      security_groups    = lookup(ingress.value, "security_groups", null)
      prefix_list_ids    = lookup(ingress.value, "prefix_list_ids", null)
      self               = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress_rules
    content {
      description        = egress.value.description
      from_port          = egress.value.from_port
      to_port            = egress.value.to_port
      protocol           = egress.value.protocol
      cidr_blocks        = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks   = lookup(egress.value, "ipv6_cidr_blocks", null)
      security_groups    = lookup(egress.value, "security_groups", null)
      prefix_list_ids    = lookup(egress.value, "prefix_list_ids", null)
      self               = lookup(egress.value, "self", null)
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-default-sg"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Custom Security Groups
resource "aws_security_group" "custom" {
  for_each = var.create_vpc ? var.custom_security_groups : {}

  name_prefix = "${var.vpc_name}-${each.value.name}-sg-"
  vpc_id      = aws_vpc.main[0].id
  description = each.value.description

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      description        = ingress.value.description
      from_port          = ingress.value.from_port
      to_port            = ingress.value.to_port
      protocol           = ingress.value.protocol
      cidr_blocks        = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks   = lookup(ingress.value, "ipv6_cidr_blocks", null)
      security_groups    = lookup(ingress.value, "security_groups", null)
      prefix_list_ids    = lookup(ingress.value, "prefix_list_ids", null)
      self               = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      description        = egress.value.description
      from_port          = egress.value.from_port
      to_port            = egress.value.to_port
      protocol           = egress.value.protocol
      cidr_blocks        = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks   = lookup(egress.value, "ipv6_cidr_blocks", null)
      security_groups    = lookup(egress.value, "security_groups", null)
      prefix_list_ids    = lookup(egress.value, "prefix_list_ids", null)
      self               = lookup(egress.value, "self", null)
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-${each.value.name}-sg"
    },
    each.value.tags,
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# =============================================================================
# VPC Endpoints Configuration
# =============================================================================

# S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  count = var.create_vpc && var.create_vpc_endpoints.s3 ? 1 : 0

  vpc_id       = aws_vpc.main[0].id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  
  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(aws_route_table.private[*].id, aws_route_table.database[*].id)

  tags = merge(
    {
      Name = "${var.vpc_name}-s3-endpoint"
    },
    var.tags
  )
}

# DynamoDB VPC Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.create_vpc && var.create_vpc_endpoints.dynamodb ? 1 : 0

  vpc_id       = aws_vpc.main[0].id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  
  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(aws_route_table.private[*].id, aws_route_table.database[*].id)

  tags = merge(
    {
      Name = "${var.vpc_name}-dynamodb-endpoint"
    },
    var.tags
  )
}

# Interface VPC Endpoints
resource "aws_vpc_endpoint" "interface" {
  for_each = var.create_vpc ? var.interface_vpc_endpoints : {}

  vpc_id              = aws_vpc.main[0].id
  service_name        = each.value.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = each.value.subnet_ids
  security_group_ids  = each.value.security_group_ids
  private_dns_enabled = each.value.private_dns_enabled

  tags = merge(
    {
      Name = "${var.vpc_name}-${each.value.name}-endpoint"
    },
    each.value.tags,
    var.tags
  )
}

# =============================================================================
# Network ACL Configuration
# =============================================================================

# Public Network ACL
resource "aws_network_acl" "public" {
  count = var.create_vpc && var.create_network_acls ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  dynamic "ingress" {
    for_each = var.public_network_acl_ingress_rules
    content {
      rule_no    = ingress.value.rule_number
      protocol   = ingress.value.protocol
      action     = ingress.value.rule_action
      cidr_block = lookup(ingress.value, "cidr_block", null)
      icmp_type  = lookup(ingress.value, "icmp_type", null)
      icmp_code  = lookup(ingress.value, "icmp_code", null)
      from_port  = lookup(ingress.value, "from_port", null)
      to_port    = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.public_network_acl_egress_rules
    content {
      rule_no    = egress.value.rule_number
      protocol   = egress.value.protocol
      action     = egress.value.rule_action
      cidr_block = lookup(egress.value, "cidr_block", null)
      icmp_type  = lookup(egress.value, "icmp_type", null)
      icmp_code  = lookup(egress.value, "icmp_code", null)
      from_port  = lookup(egress.value, "from_port", null)
      to_port    = lookup(egress.value, "to_port", null)
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-public-nacl"
    },
    var.network_acl_tags,
    var.tags
  )
}

# Private Network ACL
resource "aws_network_acl" "private" {
  count = var.create_vpc && var.create_network_acls ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  dynamic "ingress" {
    for_each = var.private_network_acl_ingress_rules
    content {
      rule_no    = ingress.value.rule_number
      protocol   = ingress.value.protocol
      action     = ingress.value.rule_action
      cidr_block = lookup(ingress.value, "cidr_block", null)
      icmp_type  = lookup(ingress.value, "icmp_type", null)
      icmp_code  = lookup(ingress.value, "icmp_code", null)
      from_port  = lookup(ingress.value, "from_port", null)
      to_port    = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.private_network_acl_egress_rules
    content {
      rule_no    = egress.value.rule_number
      protocol   = egress.value.protocol
      action     = egress.value.rule_action
      cidr_block = lookup(egress.value, "cidr_block", null)
      icmp_type  = lookup(egress.value, "icmp_type", null)
      icmp_code  = lookup(egress.value, "icmp_code", null)
      from_port  = lookup(egress.value, "from_port", null)
      to_port    = lookup(egress.value, "to_port", null)
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-private-nacl"
    },
    var.network_acl_tags,
    var.tags
  )
}

# Network ACL Associations
resource "aws_network_acl_association" "public" {
  count = var.create_vpc && var.create_network_acls ? length(var.public_subnets) : 0

  network_acl_id = aws_network_acl.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_network_acl_association" "private" {
  count = var.create_vpc && var.create_network_acls ? length(var.private_subnets) : 0

  network_acl_id = aws_network_acl.private[0].id
  subnet_id      = aws_subnet.private[count.index].id
}

# =============================================================================
# DHCP Options Configuration
# =============================================================================

resource "aws_vpc_dhcp_options" "main" {
  count = var.create_vpc && var.create_dhcp_options ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(
    {
      Name = "${var.vpc_name}-dhcp-options"
    },
    var.dhcp_options_tags,
    var.tags
  )
}

resource "aws_vpc_dhcp_options_association" "main" {
  count = var.create_vpc && var.create_dhcp_options ? 1 : 0

  vpc_id          = aws_vpc.main[0].id
  dhcp_options_id = aws_vpc_dhcp_options.main[0].id
}

# =============================================================================
# Flow Logs Configuration
# =============================================================================

# CloudWatch Log Group for Flow Logs
resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.create_vpc && var.create_flow_logs && var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0

  name              = var.flow_log_cloudwatch_log_group_name != null ? var.flow_log_cloudwatch_log_group_name : "${var.vpc_name}-flow-logs"
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days

  tags = merge(
    {
      Name = "${var.vpc_name}-flow-logs"
    },
    var.flow_log_tags,
    var.tags
  )
}

# IAM Role for Flow Logs
resource "aws_iam_role" "flow_logs" {
  count = var.create_vpc && var.create_flow_logs ? 1 : 0

  name = "${var.vpc_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "${var.vpc_name}-flow-logs-role"
    },
    var.flow_log_tags,
    var.tags
  )
}

# IAM Policy for Flow Logs
resource "aws_iam_role_policy" "flow_logs" {
  count = var.create_vpc && var.create_flow_logs ? 1 : 0

  name = "${var.vpc_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# VPC Flow Log
resource "aws_flow_log" "main" {
  count = var.create_vpc && var.create_flow_logs ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  log_destination_type = var.flow_log_destination_type
  log_format          = var.flow_log_log_format
  max_aggregation_interval = var.flow_log_max_aggregation_interval
  traffic_type        = var.flow_log_traffic_type

  dynamic "log_destination" {
    for_each = var.flow_log_destination_type == "cloud-watch-logs" ? [1] : []
    content {
      log_group_arn = aws_cloudwatch_log_group.flow_logs[0].arn
    }
  }

  dynamic "log_destination" {
    for_each = var.flow_log_destination_type == "s3" ? [1] : []
    content {
      s3_bucket_arn = var.flow_log_s3_bucket_arn
    }
  }

  dynamic "log_destination" {
    for_each = var.flow_log_destination_type == "kinesis-data-firehose" ? [1] : []
    content {
      kinesis_firehose_delivery_stream_arn = var.flow_log_kinesis_firehose_delivery_stream_arn
    }
  }

  iam_role_arn = aws_iam_role.flow_logs[0].arn

  tags = merge(
    {
      Name = "${var.vpc_name}-flow-logs"
    },
    var.flow_log_tags,
    var.tags
  )
}

# =============================================================================
# Data Sources
# =============================================================================

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
} 