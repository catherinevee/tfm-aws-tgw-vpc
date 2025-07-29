# Advanced AWS Networking Terraform Module

A comprehensive Terraform module for creating advanced AWS networking infrastructure that combines VPC, Transit Gateway, Security Groups, and VPC Endpoints into a single, cohesive module.

## Features

- **Complete VPC Setup**: Full VPC configuration with IPv4 and IPv6 support
- **Multi-Tier Subnet Architecture**: Public, private, and database subnets across multiple AZs
- **Transit Gateway Integration**: Centralized network hub for connecting VPCs and on-premises networks
- **Advanced Security Groups**: Flexible security group configuration with custom rules
- **VPC Endpoints**: Gateway and interface endpoints for AWS services
- **NAT Gateway Management**: Configurable NAT gateways for private subnet internet access
- **Route Table Management**: Comprehensive routing configuration
- **IPv6 Support**: Full IPv6 support for modern networking requirements
- **Comprehensive Tagging**: Consistent resource tagging across all components

## Architecture

This module creates a complete networking infrastructure with the following components:

```
┌─────────────────────────────────────────────────────────────────┐
│                        Transit Gateway                          │
│                    (Optional Hub)                              │
└─────────────────────────┬───────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────────┐
│                            VPC                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Public    │  │   Private   │  │  Database   │            │
│  │   Subnets   │  │   Subnets   │  │   Subnets   │            │
│  │             │  │             │  │             │            │
│  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │            │
│  │ │   AZ-A  │ │  │ │   AZ-A  │ │  │ │   AZ-A  │ │            │
│  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │            │
│  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │            │
│  │ │   AZ-B  │ │  │ │   AZ-B  │ │  │ │   AZ-B  │ │            │
│  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│         │                 │                 │                  │
│  ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐          │
│  │ Internet    │   │ NAT         │   │ NAT         │          │
│  │ Gateway     │   │ Gateway     │   │ Gateway     │          │
│  └─────────────┘   └─────────────┘   └─────────────┘          │
│         │                 │                 │                  │
│  ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐          │
│  │ Route       │   │ Route       │   │ Route       │          │
│  │ Tables      │   │ Tables      │   │ Tables      │          │
│  └─────────────┘   └─────────────┘   └─────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

## Usage

### Basic VPC with Transit Gateway

```hcl
module "advanced_networking" {
  source = "./tfm-aws-tgw-vpc/tfm-aws-tgw-vpc"

  # VPC Configuration
  vpc_name = "production-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Availability Zones and Subnets
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnets   = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  # Transit Gateway
  create_transit_gateway = true
  tgw_name              = "production-tgw"
  create_tgw_route_tables = true
  tgw_route_tables = [
    {
      name = "shared-services"
      tags = {
        Purpose = "shared-services"
      }
    },
    {
      name = "production"
      tags = {
        Purpose = "production"
      }
    }
  ]

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
    }
  }

  # VPC Endpoints
  create_vpc_endpoints = {
    s3       = true
    dynamodb = true
  }

  interface_vpc_endpoints = {
    ssm = {
      name                = "ssm"
      service_name        = "com.amazonaws.us-west-2.ssm"
      subnet_ids          = ["subnet-private-1", "subnet-private-2"]
      private_dns_enabled = true
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

### IPv6 Enabled VPC

```hcl
module "ipv6_networking" {
  source = "./tfm-aws-tgw-vpc/tfm-aws-tgw-vpc"

  vpc_name = "ipv6-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Enable IPv6
  enable_ipv6 = true
  ipv6_cidr_block = "2001:db8::/56"
  
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
  
  # IPv6 CIDR blocks for subnets
  public_subnet_ipv6_cidrs  = ["2001:db8::/64", "2001:db8:0:1::/64"]
  private_subnet_ipv6_cidrs = ["2001:db8:0:2::/64", "2001:db8:0:3::/64"]
  
  # Enable egress-only internet gateway for IPv6
  create_egress_only_igw = true

  tags = {
    Environment = "production"
    IPv6Enabled = "true"
  }
}
```

### Multi-Account Transit Gateway Hub

```hcl
module "transit_gateway_hub" {
  source = "./tfm-aws-tgw-vpc/tfm-aws-tgw-vpc"

  # Transit Gateway Configuration
  create_transit_gateway = true
  tgw_name              = "multi-account-hub"
  tgw_description       = "Central Transit Gateway for multi-account architecture"
  tgw_amazon_side_asn   = 64512
  
  # Transit Gateway Route Tables
  create_tgw_route_tables = true
  tgw_route_tables = [
    {
      name = "shared-services"
      tags = {
        Purpose = "shared-services"
      }
    },
    {
      name = "development"
      tags = {
        Purpose = "development"
      }
    },
    {
      name = "staging"
      tags = {
        Purpose = "staging"
      }
    },
    {
      name = "production"
      tags = {
        Purpose = "production"
      }
    }
  ]

  # VPC Configuration (if creating a VPC in this account)
  create_vpc = false  # Set to false if only creating Transit Gateway

  tags = {
    Environment = "shared"
    Purpose     = "transit-gateway-hub"
  }
}
```

### Development Environment

```hcl
module "dev_networking" {
  source = "./tfm-aws-tgw-vpc/tfm-aws-tgw-vpc"

  vpc_name = "development-vpc"
  vpc_cidr = "10.1.0.0/16"
  
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets    = ["10.1.11.0/24", "10.1.12.0/24"]
  
  # Single NAT Gateway for cost optimization
  enable_nat_gateway = true
  single_nat_gateway = true
  
  # Minimal security groups
  create_default_security_group = true
  custom_security_groups = {
    dev = {
      name        = "dev-sg"
      description = "Security group for development resources"
      ingress_rules = [
        {
          description = "SSH"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.1.0.0/16"]
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

  tags = {
    Environment = "development"
    Project     = "my-project"
    CostCenter  = "dev"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Inputs

### VPC Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpc | Whether to create a VPC | `bool` | `true` | no |
| vpc_cidr | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| vpc_name | Name of the VPC | `string` | `"advanced-vpc"` | no |
| instance_tenancy | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |

### IPv6 Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_ipv6 | Should be true to enable IPv6 support in the VPC and subnets | `bool` | `false` | no |
| ipv6_cidr_block | The IPv6 CIDR block for the VPC | `string` | `null` | no |
| public_subnet_ipv6_cidrs | List of IPv6 CIDR blocks for public subnets | `list(string)` | `[]` | no |
| private_subnet_ipv6_cidrs | List of IPv6 CIDR blocks for private subnets | `list(string)` | `[]` | no |
| database_subnet_ipv6_cidrs | List of IPv6 CIDR blocks for database subnets | `list(string)` | `[]` | no |

### Subnet Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability_zones | List of availability zones to use for subnets | `list(string)` | `[]` | yes |
| public_subnets | List of CIDR blocks for public subnets | `list(string)` | `[]` | no |
| private_subnets | List of CIDR blocks for private subnets | `list(string)` | `[]` | no |
| database_subnets | List of CIDR blocks for database subnets | `list(string)` | `[]` | no |
| map_public_ip_on_launch | Should be true if you want to auto-assign public IP on launch | `bool` | `true` | no |

### Transit Gateway Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_transit_gateway | Whether to create a Transit Gateway | `bool` | `false` | no |
| tgw_name | Name of the Transit Gateway | `string` | `"main-tgw"` | no |
| tgw_description | Description of the Transit Gateway | `string` | `"Main Transit Gateway"` | no |
| tgw_amazon_side_asn | Private Autonomous System Number (ASN) for the Amazon side of a BGP session | `number` | `64512` | no |
| create_tgw_route_tables | Whether to create Transit Gateway route tables | `bool` | `false` | no |
| tgw_route_tables | List of Transit Gateway route tables to create | `list(object)` | `[]` | no |

### Security Group Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_default_security_group | Should be true if you want to create a default security group | `bool` | `true` | no |
| default_security_group_ingress_rules | List of ingress rules for the default security group | `list(object)` | See variables.tf | no |
| default_security_group_egress_rules | List of egress rules for the default security group | `list(object)` | See variables.tf | no |
| custom_security_groups | Map of custom security groups to create | `map(object)` | `{}` | no |

### VPC Endpoints Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpc_endpoints | Configuration for VPC endpoints to create | `object` | `{}` | no |
| interface_vpc_endpoints | Map of interface VPC endpoints to create | `map(object)` | `{}` | no |

### Tagging

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc_tags | Additional tags for the VPC | `map(string)` | `{}` | no |
| public_subnet_tags | Additional tags for the public subnets | `map(string)` | `{}` | no |
| private_subnet_tags | Additional tags for the private subnets | `map(string)` | `{}` | no |
| database_subnet_tags | Additional tags for the database subnets | `map(string)` | `{}` | no |
| tgw_tags | Additional tags for the Transit Gateway | `map(string)` | `{}` | no |

## Outputs

### VPC Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_ipv6_cidr_block | The IPv6 CIDR block of the VPC |
| vpc_default_security_group_id | The ID of the security group created by default on VPC creation |

### Subnet Outputs

| Name | Description |
|------|-------------|
| public_subnet_ids | List of IDs of public subnets |
| private_subnet_ids | List of IDs of private subnets |
| database_subnet_ids | List of IDs of database subnets |
| public_subnet_cidr_blocks | List of cidr_blocks of public subnets |
| private_subnet_cidr_blocks | List of cidr_blocks of private subnets |
| database_subnet_cidr_blocks | List of cidr_blocks of database subnets |

### Transit Gateway Outputs

| Name | Description |
|------|-------------|
| transit_gateway_id | The ID of the Transit Gateway |
| transit_gateway_arn | The ARN of the Transit Gateway |
| transit_gateway_route_table_ids | List of Transit Gateway route table IDs |
| transit_gateway_vpc_attachment_id | The ID of the Transit Gateway VPC attachment |

### Security Group Outputs

| Name | Description |
|------|-------------|
| default_security_group_id | The ID of the default security group |
| custom_security_group_ids | Map of custom security group IDs |
| custom_security_group_arns | Map of custom security group ARNs |

### VPC Endpoint Outputs

| Name | Description |
|------|-------------|
| vpc_endpoint_s3_id | The ID of the S3 VPC endpoint |
| vpc_endpoint_dynamodb_id | The ID of the DynamoDB VPC endpoint |
| vpc_endpoint_interface_ids | Map of interface VPC endpoint IDs |

### Summary Outputs

| Name | Description |
|------|-------------|
| vpc_summary | Summary of VPC resources created |
| transit_gateway_summary | Summary of Transit Gateway resources created |

## Examples

See the `examples/` directory for complete usage examples:

- `examples/basic/` - Basic VPC with Transit Gateway
- `examples/ipv6/` - IPv6 enabled VPC
- `examples/multi-account/` - Multi-account Transit Gateway hub
- `examples/development/` - Development environment setup

## Testing

See the `test/` directory for test configurations:

- `test/main.tf` - Test networking configurations
- `test/outputs.tf` - Test outputs

## Best Practices

### Security

1. **Principle of Least Privilege**: Configure security groups with minimal required access
2. **Network Segmentation**: Use separate subnets for different tiers (public, private, database)
3. **VPC Endpoints**: Use VPC endpoints to keep traffic within AWS network
4. **Transit Gateway**: Centralize network connectivity for better security management

### Cost Optimization

1. **Single NAT Gateway**: Use single NAT gateway for development environments
2. **VPC Endpoints**: Use VPC endpoints to reduce NAT Gateway costs
3. **Resource Tagging**: Implement comprehensive tagging for cost allocation
4. **Right-sizing**: Choose appropriate subnet sizes to avoid IP address waste

### High Availability

1. **Multi-AZ Deployment**: Deploy resources across multiple availability zones
2. **Redundant NAT Gateways**: Use multiple NAT gateways for production environments
3. **Transit Gateway**: Use Transit Gateway for centralized, highly available connectivity

### Monitoring and Logging

1. **VPC Flow Logs**: Enable VPC flow logs for network monitoring
2. **CloudWatch Alarms**: Set up monitoring for NAT Gateway and Transit Gateway
3. **Resource Tagging**: Use consistent tagging for resource tracking

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the MIT License. See LICENSE file for details.

## Changelog

### Version 1.0.0
- Initial release
- Complete VPC configuration with IPv4 and IPv6 support
- Transit Gateway integration
- Advanced security group management
- VPC endpoints support
- Comprehensive outputs and documentation