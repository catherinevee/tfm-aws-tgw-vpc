# =============================================================================
# VPC Configuration Variables
# =============================================================================

variable "create_vpc" {
  description = "Whether to create a VPC"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR block must be a valid CIDR notation."
  }
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "advanced-vpc"

  validation {
    condition     = length(var.vpc_name) > 0 && length(var.vpc_name) <= 255
    error_message = "VPC name must be between 1 and 255 characters."
  }
}

variable "vpc_description" {
  description = "Description of the VPC"
  type        = string
  default     = null
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "Instance tenancy must be either 'default' or 'dedicated'."
  }
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Should be true to enable network address usage metrics in the VPC"
  type        = bool
  default     = false
}

variable "ipv4_ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR"
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC"
  type        = number
  default     = null

  validation {
    condition     = var.ipv4_netmask_length == null || (var.ipv4_netmask_length >= 8 && var.ipv4_netmask_length <= 32)
    error_message = "IPv4 netmask length must be between 8 and 32."
  }
}

variable "ipv6_cidr_block" {
  description = "The IPv6 CIDR block for the VPC"
  type        = string
  default     = null

  validation {
    condition     = var.ipv6_cidr_block == null || can(cidrhost(var.ipv6_cidr_block, 0))
    error_message = "IPv6 CIDR block must be a valid CIDR notation."
  }
}

variable "ipv6_ipam_pool_id" {
  description = "The ID of an IPv6 IPAM pool you want to use for allocating this VPC's CIDR"
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "The netmask length of the IPv6 CIDR you want to allocate to this VPC"
  type        = number
  default     = null

  validation {
    condition     = var.ipv6_netmask_length == null || (var.ipv6_netmask_length >= 32 && var.ipv6_netmask_length <= 128)
    error_message = "IPv6 netmask length must be between 32 and 128."
  }
}

variable "ipv6_cidr_block_network_border_group" {
  description = "The name of the location from which we advertise the IPV6 CIDR block"
  type        = string
  default     = null
}

# =============================================================================
# IPv6 Configuration Variables
# =============================================================================

variable "enable_ipv6" {
  description = "Should be true to enable IPv6 support in the VPC and subnets"
  type        = bool
  default     = false
}

variable "public_subnet_ipv6_cidrs" {
  description = "List of IPv6 CIDR blocks for public subnets"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.public_subnet_ipv6_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet IPv6 CIDR blocks must be valid CIDR notation."
  }
}

variable "private_subnet_ipv6_cidrs" {
  description = "List of IPv6 CIDR blocks for private subnets"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_ipv6_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All private subnet IPv6 CIDR blocks must be valid CIDR notation."
  }
}

variable "database_subnet_ipv6_cidrs" {
  description = "List of IPv6 CIDR blocks for database subnets"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.database_subnet_ipv6_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All database subnet IPv6 CIDR blocks must be valid CIDR notation."
  }
}

# =============================================================================
# Subnet Configuration Variables
# =============================================================================

variable "availability_zones" {
  description = "List of availability zones to use for subnets"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.public_subnets : can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.private_subnets : can(cidrhost(cidr, 0))
    ])
    error_message = "All private subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "database_subnets" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.database_subnets : can(cidrhost(cidr, 0))
    ])
    error_message = "All database subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "map_public_ip_on_launch" {
  description = "Should be true if you want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "map_customer_owned_ip_on_launch" {
  description = "Should be true if you want to auto-assign customer owned IP on launch"
  type        = bool
  default     = false
}

variable "customer_owned_ipv4_pool" {
  description = "The customer owned IPv4 address pool to use for auto-assign"
  type        = string
  default     = null
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Should be true if you want to enable DNS A record on launch"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Should be true if you want to enable DNS AAAA record on launch"
  type        = bool
  default     = false
}

# =============================================================================
# Internet Gateway Configuration Variables
# =============================================================================

variable "create_igw" {
  description = "Should be true if you want to create an Internet Gateway for the VPC"
  type        = bool
  default     = true
}

variable "create_egress_only_igw" {
  description = "Should be true if you want to create an Egress Only Internet Gateway for IPv6"
  type        = bool
  default     = false
}

# =============================================================================
# NAT Gateway Configuration Variables
# =============================================================================

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "nat_eip_configuration" {
  description = "Configuration for NAT Gateway EIPs"
  type = object({
    address = optional(string, null)
    network_border_group = optional(string, null)
    public_ipv4_pool = optional(string, null)
    carrier_ip = optional(string, null)
    customer_owned_ipv4_pool = optional(string, null)
    instance = optional(string, null)
    network_interface = optional(string, null)
    private_ipv4_address = optional(string, null)
    associate_with_private_ip = optional(string, null)
    vpc = optional(bool, true)
  })
  default = {}
}

variable "nat_gateway_configuration" {
  description = "Configuration for NAT Gateways"
  type = object({
    connectivity_type = optional(string, "public")
    private_ip = optional(string, null)
    secondary_allocation_ids = optional(list(string), null)
    secondary_private_ip_addresses = optional(list(string), null)
    secondary_private_ip_address_count = optional(number, null)
  })
  default = {}
}

# =============================================================================
# Route Table Configuration Variables
# =============================================================================

variable "create_route_tables" {
  description = "Whether to create custom route tables"
  type        = bool
  default     = true
}

variable "public_route_table_routes" {
  description = "Additional routes for public route table"
  type = list(object({
    cidr_block                = optional(string)
    ipv6_cidr_block          = optional(string)
    destination_prefix_list_id = optional(string)
    gateway_id                = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)
    egress_only_gateway_id    = optional(string)
    core_network_arn          = optional(string)
  }))
  default = []
}

variable "private_route_table_routes" {
  description = "Additional routes for private route tables"
  type = list(object({
    az_index = optional(number, 0)
    cidr_block                = optional(string)
    ipv6_cidr_block          = optional(string)
    destination_prefix_list_id = optional(string)
    gateway_id                = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)
    egress_only_gateway_id    = optional(string)
    core_network_arn          = optional(string)
  }))
  default = []
}

variable "database_route_table_routes" {
  description = "Additional routes for database route tables"
  type = list(object({
    az_index = optional(number, 0)
    cidr_block                = optional(string)
    ipv6_cidr_block          = optional(string)
    destination_prefix_list_id = optional(string)
    gateway_id                = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)
    egress_only_gateway_id    = optional(string)
    core_network_arn          = optional(string)
  }))
  default = []
}

# =============================================================================
# Security Group Configuration Variables
# =============================================================================

variable "create_default_security_group" {
  description = "Should be true if you want to create a default security group"
  type        = bool
  default     = true
}

variable "default_security_group_ingress_rules" {
  description = "List of ingress rules for the default security group"
  type = list(object({
    description        = string
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = optional(list(string))
    ipv6_cidr_blocks   = optional(list(string))
    security_groups    = optional(list(string))
    prefix_list_ids    = optional(list(string))
    self               = optional(bool)
  }))
  default = [
    {
      description = "Allow all internal traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = true
    }
  ]
}

variable "default_security_group_egress_rules" {
  description = "List of egress rules for the default security group"
  type = list(object({
    description        = string
    from_port          = number
    to_port            = number
    protocol           = string
    cidr_blocks        = optional(list(string))
    ipv6_cidr_blocks   = optional(list(string))
    security_groups    = optional(list(string))
    prefix_list_ids    = optional(list(string))
    self               = optional(bool)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "custom_security_groups" {
  description = "Map of custom security groups to create"
  type = map(object({
    name        = string
    description = string
    ingress_rules = list(object({
      description        = string
      from_port          = number
      to_port            = number
      protocol           = string
      cidr_blocks        = optional(list(string))
      ipv6_cidr_blocks   = optional(list(string))
      security_groups    = optional(list(string))
      prefix_list_ids    = optional(list(string))
      self               = optional(bool)
    }))
    egress_rules = list(object({
      description        = string
      from_port          = number
      to_port            = number
      protocol           = string
      cidr_blocks        = optional(list(string))
      ipv6_cidr_blocks   = optional(list(string))
      security_groups    = optional(list(string))
      prefix_list_ids    = optional(list(string))
      self               = optional(bool)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# =============================================================================
# Network ACL Configuration Variables
# =============================================================================

variable "create_network_acls" {
  description = "Whether to create Network ACLs"
  type        = bool
  default     = false
}

variable "public_network_acl_ingress_rules" {
  description = "Ingress rules for public Network ACL"
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    egress      = optional(bool, false)
    cidr_block  = optional(string)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
    }
  ]
}

variable "public_network_acl_egress_rules" {
  description = "Egress rules for public Network ACL"
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    egress      = optional(bool, true)
    cidr_block  = optional(string)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
    }
  ]
}

variable "private_network_acl_ingress_rules" {
  description = "Ingress rules for private Network ACL"
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    egress      = optional(bool, false)
    cidr_block  = optional(string)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
    }
  ]
}

variable "private_network_acl_egress_rules" {
  description = "Egress rules for private Network ACL"
  type = list(object({
    rule_number = number
    protocol    = string
    rule_action = string
    egress      = optional(bool, true)
    cidr_block  = optional(string)
    icmp_type   = optional(number)
    icmp_code   = optional(number)
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
    }
  ]
}

# =============================================================================
# DHCP Options Configuration Variables
# =============================================================================

variable "create_dhcp_options" {
  description = "Whether to create DHCP Options"
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "The domain name for the DHCP options"
  type        = string
  default     = null
}

variable "dhcp_options_domain_name_servers" {
  description = "List of domain name servers for the DHCP options"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "List of NTP servers for the DHCP options"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "List of NetBIOS name servers for the DHCP options"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "The NetBIOS node type for the DHCP options"
  type        = string
  default     = null
}

# =============================================================================
# Flow Logs Configuration Variables
# =============================================================================

variable "create_flow_logs" {
  description = "Whether to create VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_destination_type" {
  description = "The type of destination for the flow log"
  type        = string
  default     = "cloud-watch-logs"

  validation {
    condition     = contains(["cloud-watch-logs", "s3", "kinesis-data-firehose"], var.flow_log_destination_type)
    error_message = "Flow log destination type must be one of: cloud-watch-logs, s3, kinesis-data-firehose."
  }
}

variable "flow_log_log_format" {
  description = "The fields to include in the flow log record"
  type        = string
  default     = null
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record"
  type        = number
  default     = 600

  validation {
    condition     = contains([60, 600], var.flow_log_max_aggregation_interval)
    error_message = "Flow log max aggregation interval must be either 60 or 600 seconds."
  }
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture"
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "Flow log traffic type must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "flow_log_cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group for flow logs"
  type        = string
  default     = null
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch Log Group logs"
  type        = number
  default     = 7
}

variable "flow_log_s3_bucket_name" {
  description = "The name of the S3 bucket for flow logs"
  type        = string
  default     = null
}

variable "flow_log_s3_bucket_arn" {
  description = "The ARN of the S3 bucket for flow logs"
  type        = string
  default     = null
}

variable "flow_log_kinesis_firehose_delivery_stream_arn" {
  description = "The ARN of the Kinesis Firehose delivery stream for flow logs"
  type        = string
  default     = null
}

# =============================================================================
# Transit Gateway Configuration Variables
# =============================================================================

variable "create_transit_gateway" {
  description = "Whether to create a Transit Gateway"
  type        = bool
  default     = false
}

variable "tgw_name" {
  description = "Name of the Transit Gateway"
  type        = string
  default     = "main-tgw"
}

variable "tgw_description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Main Transit Gateway"
}

variable "tgw_amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "tgw_auto_accept_shared_attachments" {
  description = "Whether resource attachments are automatically accepted"
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.tgw_auto_accept_shared_attachments)
    error_message = "Auto accept shared attachments must be either 'disable' or 'enable'."
  }
}

variable "tgw_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.tgw_default_route_table_association)
    error_message = "Default route table association must be either 'disable' or 'enable'."
  }
}

variable "tgw_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.tgw_default_route_table_propagation)
    error_message = "Default route table propagation must be either 'disable' or 'enable'."
  }
}

variable "tgw_dns_support" {
  description = "Whether DNS support is enabled"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.tgw_dns_support)
    error_message = "DNS support must be either 'disable' or 'enable'."
  }
}

variable "tgw_multicast_support" {
  description = "Whether multicast support is enabled"
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.tgw_multicast_support)
    error_message = "Multicast support must be either 'disable' or 'enable'."
  }
}

variable "tgw_cidr_blocks" {
  description = "One or more IPv4 or IPv6 CIDR blocks for the Transit Gateway"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.tgw_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "All Transit Gateway CIDR blocks must be valid CIDR notation."
  }
}

variable "tgw_vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.tgw_vpn_ecmp_support)
    error_message = "VPN ECMP support must be either 'disable' or 'enable'."
  }
}

variable "create_tgw_route_tables" {
  description = "Whether to create Transit Gateway route tables"
  type        = bool
  default     = false
}

variable "tgw_route_tables" {
  description = "List of Transit Gateway route tables to create"
  type = list(object({
    name = string
    tags = optional(map(string), {})
  }))
  default = []
}

variable "tgw_vpc_attachment" {
  description = "Configuration for Transit Gateway VPC attachment"
  type = object({
    appliance_mode_support                          = optional(string, "disable")
    dns_support                                     = optional(string, "enable")
    ipv6_support                                    = optional(string, "disable")
    transit_gateway_default_route_table_association = optional(string, "enable")
    transit_gateway_default_route_table_propagation = optional(string, "enable")
  })
  default = {}
}

variable "create_tgw_routes" {
  description = "Whether to create Transit Gateway routes"
  type        = bool
  default     = false
}

variable "tgw_routes" {
  description = "List of Transit Gateway routes to create"
  type = list(object({
    destination_cidr_block         = string
    transit_gateway_attachment_id  = string
    transit_gateway_route_table_id = string
  }))
  default = []
}

variable "create_tgw_route_table_associations" {
  description = "Whether to create Transit Gateway route table associations"
  type        = bool
  default     = false
}

variable "tgw_route_table_associations" {
  description = "List of Transit Gateway route table associations to create"
  type = list(object({
    transit_gateway_attachment_id  = string
    transit_gateway_route_table_id = string
  }))
  default = []
}

variable "create_tgw_route_table_propagations" {
  description = "Whether to create Transit Gateway route table propagations"
  type        = bool
  default     = false
}

variable "tgw_route_table_propagations" {
  description = "List of Transit Gateway route table propagations to create"
  type = list(object({
    transit_gateway_attachment_id  = string
    transit_gateway_route_table_id = string
  }))
  default = []
}

# =============================================================================
# VPC Endpoints Configuration Variables
# =============================================================================

variable "create_vpc_endpoints" {
  description = "Configuration for VPC endpoints to create"
  type = object({
    s3       = optional(bool, false)
    dynamodb = optional(bool, false)
  })
  default = {}
}

variable "interface_vpc_endpoints" {
  description = "Map of interface VPC endpoints to create"
  type = map(object({
    name                = string
    service_name        = string
    subnet_ids          = list(string)
    security_group_ids  = optional(list(string), [])
    private_dns_enabled = optional(bool, true)
    ip_address_type     = optional(string, "ipv4")
    policy              = optional(string, null)
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "gateway_vpc_endpoints" {
  description = "Map of gateway VPC endpoints to create"
  type = map(object({
    name              = string
    service_name      = string
    route_table_ids   = list(string)
    policy            = optional(string, null)
    tags              = optional(map(string), {})
  }))
  default = {}
}

variable "gateway_load_balancer_vpc_endpoints" {
  description = "Map of gateway load balancer VPC endpoints to create"
  type = map(object({
    name                = string
    service_name        = string
    subnet_ids          = list(string)
    security_group_ids  = optional(list(string), [])
    private_dns_enabled = optional(bool, true)
    tags                = optional(map(string), {})
  }))
  default = {}
}

# =============================================================================
# Tagging Variables
# =============================================================================

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets"
  type        = map(string)
  default     = {}
}

variable "tgw_tags" {
  description = "Additional tags for the Transit Gateway"
  type        = map(string)
  default     = {}
}

variable "internet_gateway_tags" {
  description = "Additional tags for the Internet Gateway"
  type        = map(string)
  default     = {}
}

variable "egress_only_internet_gateway_tags" {
  description = "Additional tags for the Egress Only Internet Gateway"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Additional tags for NAT Gateways"
  type        = map(string)
  default     = {}
}

variable "eip_tags" {
  description = "Additional tags for Elastic IPs"
  type        = map(string)
  default     = {}
}

variable "route_table_tags" {
  description = "Additional tags for route tables"
  type        = map(string)
  default     = {}
}

variable "network_acl_tags" {
  description = "Additional tags for Network ACLs"
  type        = map(string)
  default     = {}
}

variable "dhcp_options_tags" {
  description = "Additional tags for DHCP Options"
  type        = map(string)
  default     = {}
}

variable "flow_log_tags" {
  description = "Additional tags for Flow Logs"
  type        = map(string)
  default     = {}
}

variable "vpc_endpoint_tags" {
  description = "Additional tags for VPC Endpoints"
  type        = map(string)
  default     = {}
} 