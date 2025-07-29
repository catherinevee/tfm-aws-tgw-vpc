# Test Configuration for Advanced AWS Networking Module
# This configuration tests the module with minimal resources

module "test_networking" {
  source = "../"

  # VPC Configuration
  vpc_name = "test-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Availability Zones and Subnets (minimal for testing)
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]

  # Internet Gateway
  create_igw = true

  # NAT Gateway (single for cost optimization in testing)
  enable_nat_gateway = true
  single_nat_gateway = true

  # Transit Gateway (minimal configuration)
  create_transit_gateway = true
  tgw_name              = "test-tgw"
  tgw_description       = "Test Transit Gateway"

  # Security Groups (minimal for testing)
  create_default_security_group = true
  custom_security_groups = {
    test = {
      name        = "test-sg"
      description = "Test security group"
      ingress_rules = [
        {
          description = "SSH"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
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

  # VPC Endpoints (minimal for testing)
  create_vpc_endpoints = {
    s3 = true
  }

  tags = {
    Environment = "test"
    Project     = "networking-test"
    ManagedBy   = "terraform"
    Purpose     = "testing"
  }
} 