# IPv6 Example - VPC with IPv6 Support
# This example creates a VPC with full IPv6 support

module "ipv6_networking" {
  source = "../../"

  # VPC Configuration
  vpc_name = "ipv6-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Enable IPv6
  enable_ipv6 = true
  ipv6_cidr_block = "2001:db8::/56"
  
  # Availability Zones and Subnets
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnets   = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  
  # IPv6 CIDR blocks for subnets
  public_subnet_ipv6_cidrs  = ["2001:db8::/64", "2001:db8:0:1::/64", "2001:db8:0:2::/64"]
  private_subnet_ipv6_cidrs = ["2001:db8:0:3::/64", "2001:db8:0:4::/64", "2001:db8:0:5::/64"]
  database_subnet_ipv6_cidrs = ["2001:db8:0:6::/64", "2001:db8:0:7::/64", "2001:db8:0:8::/64"]

  # Internet Gateway
  create_igw = true

  # Egress-only Internet Gateway for IPv6
  create_egress_only_igw = true

  # NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = false

  # Transit Gateway
  create_transit_gateway = true
  tgw_name              = "ipv6-tgw"
  tgw_description       = "Transit Gateway with IPv6 support"

  # Security Groups with IPv6 support
  create_default_security_group = true
  custom_security_groups = {
    web_ipv6 = {
      name        = "web-ipv6-sg"
      description = "Security group for web servers with IPv6 support"
      ingress_rules = [
        {
          description = "HTTP IPv4"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "HTTP IPv6"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          ipv6_cidr_blocks = ["::/0"]
        },
        {
          description = "HTTPS IPv4"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "HTTPS IPv6"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          ipv6_cidr_blocks = ["::/0"]
        }
      ]
      egress_rules = [
        {
          description = "All outbound IPv4"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "All outbound IPv6"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          ipv6_cidr_blocks = ["::/0"]
        }
      ]
    }
  }

  # VPC Endpoints
  create_vpc_endpoints = {
    s3       = true
    dynamodb = true
  }

  # Interface VPC Endpoints
  interface_vpc_endpoints = {
    ssm = {
      name                = "ssm"
      service_name        = "com.amazonaws.us-west-2.ssm"
      subnet_ids          = ["subnet-private-1", "subnet-private-2"]
      private_dns_enabled = true
    },
    secretsmanager = {
      name                = "secretsmanager"
      service_name        = "com.amazonaws.us-west-2.secretsmanager"
      subnet_ids          = ["subnet-private-1", "subnet-private-2"]
      private_dns_enabled = true
    }
  }

  tags = {
    Environment = "ipv6"
    Project     = "networking-example"
    IPv6Enabled = "true"
    ManagedBy   = "terraform"
  }
} 