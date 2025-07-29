# Multi-Account Example - Transit Gateway Hub
# This example creates a Transit Gateway hub for multi-account architecture

module "transit_gateway_hub" {
  source = "../../"

  # Transit Gateway Configuration
  create_transit_gateway = true
  tgw_name              = "multi-account-hub"
  tgw_description       = "Central Transit Gateway for multi-account architecture"
  tgw_amazon_side_asn   = 64512
  
  # Transit Gateway Route Tables for different environments
  create_tgw_route_tables = true
  tgw_route_tables = [
    {
      name = "shared-services"
      tags = {
        Purpose = "shared-services"
        Environment = "shared"
      }
    },
    {
      name = "development"
      tags = {
        Purpose = "development"
        Environment = "development"
      }
    },
    {
      name = "staging"
      tags = {
        Purpose = "staging"
        Environment = "staging"
      }
    },
    {
      name = "production"
      tags = {
        Purpose = "production"
        Environment = "production"
      }
    },
    {
      name = "on-premises"
      tags = {
        Purpose = "on-premises"
        Environment = "hybrid"
      }
    }
  ]

  # VPC Configuration (if creating a VPC in this account)
  create_vpc = false  # Set to false if only creating Transit Gateway

  tags = {
    Environment = "shared"
    Purpose     = "transit-gateway-hub"
    Project     = "multi-account-networking"
    ManagedBy   = "terraform"
  }
}

# Example of how to create a VPC in a spoke account
# This would be in a separate Terraform configuration in the spoke account
module "spoke_vpc" {
  source = "../../"

  # VPC Configuration
  vpc_name = "spoke-vpc"
  vpc_cidr = "10.1.0.0/16"
  
  # Availability Zones and Subnets
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets    = ["10.1.11.0/24", "10.1.12.0/24"]
  database_subnets   = ["10.1.21.0/24", "10.1.22.0/24"]

  # Internet Gateway
  create_igw = true

  # NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true

  # Transit Gateway (reference existing Transit Gateway)
  create_transit_gateway = false  # Don't create, reference existing

  # Security Groups
  create_default_security_group = true
  custom_security_groups = {
    spoke_app = {
      name        = "spoke-app-sg"
      description = "Security group for spoke application servers"
      ingress_rules = [
        {
          description = "SSH from management subnet"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]  # Allow from hub VPC
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
    Environment = "spoke"
    Purpose     = "application-vpc"
    Project     = "multi-account-networking"
    ManagedBy   = "terraform"
  }
} 