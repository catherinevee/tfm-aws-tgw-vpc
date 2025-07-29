# Basic Example - VPC with Transit Gateway
# This example creates a basic VPC with Transit Gateway integration

module "basic_networking" {
  source = "../../"

  # VPC Configuration
  vpc_name = "basic-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Availability Zones and Subnets
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets   = ["10.0.21.0/24", "10.0.22.0/24"]

  # Internet Gateway
  create_igw = true

  # NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = false

  # Transit Gateway
  create_transit_gateway = true
  tgw_name              = "basic-tgw"
  tgw_description       = "Basic Transit Gateway for VPC connectivity"

  # Security Groups
  create_default_security_group = true
  custom_security_groups = {
    web = {
      name        = "web-sg"
      description = "Security group for web servers"
      ingress_rules = [
        {
          description = "HTTP"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "HTTPS"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [
        {
          description = "All outbound"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    app = {
      name        = "app-sg"
      description = "Security group for application servers"
      ingress_rules = [
        {
          description = "HTTP from web servers"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          security_groups = ["web-sg"]
        }
      ]
      egress_rules = [
        {
          description = "All outbound"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }

  # VPC Endpoints
  create_vpc_endpoints = {
    s3       = true
    dynamodb = true
  }

  tags = {
    Environment = "basic"
    Project     = "networking-example"
    ManagedBy   = "terraform"
  }
} 