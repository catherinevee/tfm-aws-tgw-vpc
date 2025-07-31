# Enhanced AWS TGW VPC Module

## Overview

This comprehensive AWS Terraform module provides a fully customizable VPC (Virtual Private Cloud) with Transit Gateway integration, featuring maximum parameterization for all resources. The module ensures that **each aspect of each resource contains as many customizable parameters for the user as possible**, providing unparalleled flexibility for complex networking architectures.

## Key Features

### 🚀 **Maximum Customization**
- **Every AWS parameter exposed**: All configurable aspects of each resource are available as variables
- **Comprehensive IPv6 support**: Full IPv6 configuration for VPC, subnets, and security groups
- **Advanced networking features**: Network ACLs, DHCP Options, Flow Logs, and VPC Endpoints
- **Enterprise-grade security**: Enhanced security groups with IPv6 and prefix list support

### 🌐 **Networking Components**
- **VPC**: Fully configurable with IPAM support, network metrics, and comprehensive tagging
- **Subnets**: Public, private, and database subnets with IPv6, customer-owned IPs, and DNS options
- **Internet Gateways**: Standard and Egress-Only (IPv6) gateway support
- **NAT Gateways**: Enhanced configuration with connectivity types and secondary IPs
- **Route Tables**: Custom routes with support for all AWS route targets
- **Transit Gateway**: Complete TGW configuration with route tables and attachments

### 🔒 **Security & Monitoring**
- **Security Groups**: Default and custom groups with IPv6 and prefix list support
- **Network ACLs**: Configurable ingress/egress rules for subnet-level security
- **Flow Logs**: Multiple destination types (CloudWatch, S3, Kinesis Firehose)
- **VPC Endpoints**: Interface, Gateway, and Gateway Load Balancer endpoints

### 🏷️ **Enhanced Tagging**
- **Resource-specific tags**: Individual tagging for each resource type
- **Hierarchical inheritance**: Global tags → resource-specific tags
- **Comprehensive coverage**: Tags for all resources including new features

## New Enhancements

### NAT Gateway & EIP Configuration
- **Enhanced EIP Configuration**: All Elastic IP parameters exposed including carrier IPs, customer-owned IPs, and network border groups
- **Advanced NAT Gateway Settings**: Connectivity types, private IPs, and secondary allocation support
- **Flexible IP Management**: Support for public IPv4 pools and custom IP configurations

### Route Table Enhancements
- **Additional Routes**: Custom routes for public, private, and database route tables
- **Multi-AZ Support**: Route configuration per availability zone
- **All Route Targets**: Support for gateways, NAT gateways, transit gateways, VPC endpoints, and more
- **IPv6 Routes**: Full IPv6 route support with proper destination blocks

### Output Enhancements
- **NAT Gateway Details**: Connectivity types, private IPs, and enhanced EIP information
- **Route Information**: Additional route IDs and route table owner information
- **Comprehensive Coverage**: All new resource attributes exposed as outputs

## Usage

### Basic Example

```hcl
module "enhanced_networking" {
  source = "path/to/module"

  # VPC Configuration
  vpc_name = "enhanced-vpc"
  vpc_cidr = "10.0.0.0/16"
  enable_ipv6 = true
  ipv6_cidr_block = "2001:db8::/56"

  # Subnet Configuration
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets   = ["10.0.21.0/24", "10.0.22.0/24"]

  # Enhanced NAT Gateway Configuration
  nat_eip_configuration = {
    network_border_group = "us-west-2"
    vpc = true
  }
  
  nat_gateway_configuration = {
    connectivity_type = "public"
  }

  # Additional Routes
  public_route_table_routes = [
    {
      cidr_block = "172.16.0.0/12"
      gateway_id = "igw-12345678"
    }
  ]

  # Transit Gateway
  create_transit_gateway = true
  tgw_name = "enhanced-tgw"

  # Enhanced Security Groups
  default_security_group_ingress_rules = [
    {
      description = "Allow all internal traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
      self        = true
    }
  ]

  # Network ACLs
  create_network_acls = true

  # Flow Logs
  create_flow_logs = true
  flow_log_destination_type = "cloud-watch-logs"

  # VPC Endpoints
  create_vpc_endpoints = {
    s3       = true
    dynamodb = true
  }

  tags = {
    Environment = "enhanced"
    Project     = "networking"
  }
}
```

### Advanced Example

See `examples/basic/main.tf` for a comprehensive example demonstrating all features.

## Inputs

### VPC Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | Name of the VPC | `string` | `"advanced-vpc"` | no |
| vpc_cidr | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| vpc_description | Description of the VPC | `string` | `null` | no |
| enable_network_address_usage_metrics | Enable network address usage metrics | `bool` | `false` | no |
| enable_ipv6 | Enable IPv6 support | `bool` | `false` | no |
| ipv6_cidr_block | IPv6 CIDR block for VPC | `string` | `null` | no |

### NAT Gateway Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| nat_eip_configuration | Configuration for NAT Gateway EIPs | `object` | `{}` | no |
| nat_gateway_configuration | Configuration for NAT Gateways | `object` | `{}` | no |

### Route Table Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| public_route_table_routes | Additional routes for public route table | `list(object)` | `[]` | no |
| private_route_table_routes | Additional routes for private route tables | `list(object)` | `[]` | no |
| database_route_table_routes | Additional routes for database route tables | `list(object)` | `[]` | no |

### Security Groups
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default_security_group_ingress_rules | Ingress rules for default security group | `list(object)` | See variables | no |
| default_security_group_egress_rules | Egress rules for default security group | `list(object)` | See variables | no |
| custom_security_groups | Map of custom security groups | `map(object)` | `{}` | no |

### Network ACLs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_network_acls | Whether to create Network ACLs | `bool` | `false` | no |
| public_network_acl_ingress_rules | Ingress rules for public Network ACL | `list(object)` | See variables | no |
| public_network_acl_egress_rules | Egress rules for public Network ACL | `list(object)` | See variables | no |

### Flow Logs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_flow_logs | Whether to create VPC Flow Logs | `bool` | `false` | no |
| flow_log_destination_type | Destination type for flow logs | `string` | `"cloud-watch-logs"` | no |
| flow_log_traffic_type | Traffic type to capture | `string` | `"ALL"` | no |

### Transit Gateway
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_transit_gateway | Whether to create a Transit Gateway | `bool` | `false` | no |
| tgw_name | Name of the Transit Gateway | `string` | `"main-tgw"` | no |
| tgw_amazon_side_asn | Amazon side ASN for Transit Gateway | `number` | `64512` | no |

### VPC Endpoints
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpc_endpoints | Configuration for VPC endpoints | `object` | `{}` | no |
| interface_vpc_endpoints | Map of interface VPC endpoints | `map(object)` | `{}` | no |
| gateway_vpc_endpoints | Map of gateway VPC endpoints | `map(object)` | `{}` | no |

### Tagging
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | Global tags for all resources | `map(string)` | `{}` | no |
| vpc_tags | Additional tags for VPC | `map(string)` | `{}` | no |
| nat_gateway_tags | Additional tags for NAT Gateways | `map(string)` | `{}` | no |
| route_table_tags | Additional tags for route tables | `map(string)` | `{}` | no |

## Outputs

### VPC Outputs
| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_ipv6_cidr_block | The IPv6 CIDR block of the VPC |

### NAT Gateway Outputs
| Name | Description |
|------|-------------|
| nat_gateway_ids | List of NAT Gateway IDs |
| nat_gateway_connectivity_types | List of connectivity types of NAT Gateways |
| nat_eip_ids | List of Elastic IP IDs for NAT Gateways |
| nat_eip_allocation_ids | List of Elastic IP allocation IDs |
| nat_eip_network_border_groups | List of Elastic IP network border groups |
| nat_eip_carrier_ips | List of Elastic IP carrier IPs |

### Route Table Outputs
| Name | Description |
|------|-------------|
| public_route_table_id | ID of public route table |
| public_route_table_owner_id | Owner ID of public route table |
| private_route_table_ids | List of IDs of private route tables |
| public_additional_route_ids | List of IDs of additional public routes |
| private_additional_route_ids | List of IDs of additional private routes |

### Security Group Outputs
| Name | Description |
|------|-------------|
| default_security_group_id | The ID of the default security group |
| custom_security_group_ids | Map of custom security group IDs |

### Transit Gateway Outputs
| Name | Description |
|------|-------------|
| transit_gateway_id | The ID of the Transit Gateway |
| transit_gateway_arn | The ARN of the Transit Gateway |
| transit_gateway_vpc_attachment_id | The ID of the Transit Gateway VPC attachment |

### Network ACL Outputs
| Name | Description |
|------|-------------|
| public_network_acl_id | The ID of the public Network ACL |
| private_network_acl_id | The ID of the private Network ACL |

### Flow Log Outputs
| Name | Description |
|------|-------------|
| flow_log_id | The ID of the VPC Flow Log |
| flow_log_cloudwatch_log_group_arn | The ARN of the CloudWatch Log Group |

## Default Values Philosophy

The module follows these principles for default values:

- **Security First**: Secure defaults that don't expose resources unnecessarily
- **Cost Optimization**: Features that incur costs are disabled by default
- **Simplicity**: Simple configurations work out of the box
- **Flexibility**: Advanced features available when needed
- **Backward Compatibility**: Existing configurations continue to work

## Benefits

1. **Maximum Customization**: Every aspect of every resource is now configurable
2. **IPv6 Support**: Comprehensive IPv6 support throughout the module
3. **Enterprise Features**: Network ACLs, DHCP Options, Flow Logs for enterprise use cases
4. **Flexibility**: Support for all AWS networking features and configurations
5. **Maintainability**: Well-organized, documented, and validated parameters
6. **Scalability**: Support for complex networking architectures
7. **Compliance**: Enhanced security and monitoring capabilities

## Backward Compatibility

All enhancements maintain full backward compatibility:
- All new parameters have sensible defaults
- Existing configurations continue to work without modification
- New features are opt-in (disabled by default)
- No breaking changes to existing functionality

## Contributing

This module is designed to provide maximum customization while maintaining ease of use. When adding new features, please ensure:
- All parameters are properly documented
- Default values follow the established philosophy
- Backward compatibility is maintained
- Examples are updated to demonstrate new features