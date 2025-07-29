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
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
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
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
    self            = optional(bool)
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
      description     = string
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
      self            = optional(bool)
    }))
    egress_rules = list(object({
      description     = string
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
      self            = optional(bool)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
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