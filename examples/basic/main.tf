# Enhanced Basic Example - VPC with Transit Gateway and Comprehensive Customization
# This example demonstrates all the new customizable parameters available in the module

module "enhanced_networking" {
  source = "../../"

  # =============================================================================
  # VPC Configuration
  # =============================================================================
  vpc_name = "enhanced-vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_description = "Enhanced VPC with comprehensive customization options"
  
  # Advanced VPC settings
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_network_address_usage_metrics = true
  
  # IPv6 Configuration
  enable_ipv6 = true
  ipv6_cidr_block = "2001:db8::/56"
  
  # =============================================================================
  # Subnet Configuration
  # =============================================================================
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets   = ["10.0.21.0/24", "10.0.22.0/24"]
  
  # IPv6 subnet CIDRs
  public_subnet_ipv6_cidrs   = ["2001:db8::/64", "2001:db8:0:1::/64"]
  private_subnet_ipv6_cidrs  = ["2001:db8:0:2::/64", "2001:db8:0:3::/64"]
  database_subnet_ipv6_cidrs = ["2001:db8:0:4::/64", "2001:db8:0:5::/64"]
  
  # Enhanced subnet settings
  map_public_ip_on_launch = true
  map_customer_owned_ip_on_launch = false
  enable_resource_name_dns_a_record_on_launch = true
  enable_resource_name_dns_aaaa_record_on_launch = true

  # =============================================================================
  # Internet Gateway Configuration
  # =============================================================================
  create_igw = true
  create_egress_only_igw = true

  # =============================================================================
  # NAT Gateway Configuration
  # =============================================================================
  enable_nat_gateway = true
  single_nat_gateway = false
  
  # Enhanced NAT Gateway EIP Configuration
  nat_eip_configuration = {
    address = null # Use AWS-assigned address
    network_border_group = "us-west-2"
    public_ipv4_pool = null
    carrier_ip = null
    customer_owned_ipv4_pool = null
    instance = null
    network_interface = null
    associate_with_private_ip = null
    vpc = true
  }
  
  # Enhanced NAT Gateway Configuration
  nat_gateway_configuration = {
    connectivity_type = "public"
    private_ip = null
    secondary_allocation_ids = null
    secondary_private_ip_addresses = null
    secondary_private_ip_address_count = null
  }

  # =============================================================================
  # Route Table Configuration
  # =============================================================================
  create_route_tables = true
  
  # Additional routes for public route table
  public_route_table_routes = [
    {
      cidr_block = "172.16.0.0/12"
      gateway_id = "igw-12345678" # Example external gateway
    },
    {
      ipv6_cidr_block = "2001:db8:1::/48"
      gateway_id = "igw-12345678"
    }
  ]
  
  # Additional routes for private route tables
  private_route_table_routes = [
    {
      az_index = 0
      cidr_block = "192.168.0.0/16"
      transit_gateway_id = "tgw-12345678" # Example transit gateway
    },
    {
      az_index = 1
      cidr_block = "10.1.0.0/16"
      nat_gateway_id = "nat-12345678" # Example NAT gateway
    }
  ]
  
  # Additional routes for database route tables
  database_route_table_routes = [
    {
      az_index = 0
      cidr_block = "10.2.0.0/16"
      transit_gateway_id = "tgw-12345678"
    }
  ]

  # =============================================================================
  # Security Group Configuration
  # =============================================================================
  create_default_security_group = true
  
  # Enhanced default security group with IPv6 support
  default_security_group_ingress_rules = [
    {
      description = "Allow all internal traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = true
    },
    {
      description = "Allow SSH from specific IPs"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
      ipv6_cidr_blocks = ["2001:db8::/32"]
    }
  ]
  
  default_security_group_egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  
  # Custom security groups with enhanced features
  custom_security_groups = {
    web = {
      name        = "web-sg"
      description = "Security group for web servers with IPv6 support"
      ingress_rules = [
        {
          description = "HTTP"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
        },
        {
          description = "HTTPS"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
        }
      ]
      egress_rules = [
        {
          description = "All outbound"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
        }
      ]
      tags = {
        Purpose = "Web servers"
        Environment = "Production"
      }
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
        },
        {
          description = "Database access"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
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

  # =============================================================================
  # Network ACL Configuration
  # =============================================================================
  create_network_acls = true
  
  public_network_acl_ingress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
    }
  ]
  
  public_network_acl_egress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
    }
  ]
  
  private_network_acl_ingress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/8"
    }
  ]
  
  private_network_acl_egress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
    }
  ]

  # =============================================================================
  # DHCP Options Configuration
  # =============================================================================
  create_dhcp_options = true
  dhcp_options_domain_name = "example.internal"
  dhcp_options_domain_name_servers = ["8.8.8.8", "8.8.4.4"]
  dhcp_options_ntp_servers = ["time.google.com"]
  dhcp_options_netbios_name_servers = ["10.0.0.10"]
  dhcp_options_netbios_node_type = "2"

  # =============================================================================
  # Flow Logs Configuration
  # =============================================================================
  create_flow_logs = true
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_traffic_type = "ALL"
  flow_log_max_aggregation_interval = 600
  flow_log_cloudwatch_log_group_retention_in_days = 30

  # =============================================================================
  # Transit Gateway Configuration
  # =============================================================================
  create_transit_gateway = true
  tgw_name              = "enhanced-tgw"
  tgw_description       = "Enhanced Transit Gateway with comprehensive features"
  tgw_amazon_side_asn   = 64512
  tgw_auto_accept_shared_attachments = "disable"
  tgw_default_route_table_association = "enable"
  tgw_default_route_table_propagation = "enable"
  tgw_dns_support = "enable"
  tgw_multicast_support = "disable"
  tgw_cidr_blocks = ["10.1.0.0/16"]
  tgw_vpn_ecmp_support = "enable"
  
  # Transit Gateway Route Tables
  create_tgw_route_tables = true
  tgw_route_tables = [
    {
      name = "shared-routes"
      tags = {
        Purpose = "Shared routes"
      }
    },
    {
      name = "isolated-routes"
      tags = {
        Purpose = "Isolated routes"
      }
    }
  ]
  
  # Transit Gateway VPC Attachment
  tgw_vpc_attachment = {
    appliance_mode_support = "enable"
    dns_support = "enable"
    ipv6_support = "enable"
    transit_gateway_default_route_table_association = "enable"
    transit_gateway_default_route_table_propagation = "enable"
  }

  # =============================================================================
  # VPC Endpoints Configuration
  # =============================================================================
  create_vpc_endpoints = {
    s3       = true
    dynamodb = true
  }
  
  # Interface VPC Endpoints
  interface_vpc_endpoints = {
    ssm = {
      name                = "ssm"
      service_name        = "com.amazonaws.us-west-2.ssm"
      subnet_ids          = ["subnet-12345678", "subnet-87654321"] # Example subnet IDs
      security_group_ids  = ["sg-12345678"] # Example security group ID
      private_dns_enabled = true
      ip_address_type     = "ipv4"
      tags = {
        Purpose = "Systems Manager"
      }
    },
    ec2messages = {
      name                = "ec2messages"
      service_name        = "com.amazonaws.us-west-2.ec2messages"
      subnet_ids          = ["subnet-12345678", "subnet-87654321"]
      security_group_ids  = ["sg-12345678"]
      private_dns_enabled = true
      ip_address_type     = "ipv4"
    }
  }
  
  # Gateway VPC Endpoints
  gateway_vpc_endpoints = {
    s3 = {
      name            = "s3"
      service_name    = "com.amazonaws.us-west-2.s3"
      route_table_ids = ["rtb-12345678", "rtb-87654321"] # Example route table IDs
      tags = {
        Purpose = "S3 access"
      }
    }
  }

  # =============================================================================
  # Tagging Configuration
  # =============================================================================
  tags = {
    Environment = "enhanced"
    Project     = "networking-example"
    ManagedBy   = "terraform"
    Owner       = "DevOps Team"
    CostCenter  = "IT-001"
  }
  
  # Resource-specific tags
  vpc_tags = {
    Purpose = "Enhanced VPC"
  }
  
  public_subnet_tags = {
    Tier = "Public"
    Purpose = "Public resources"
  }
  
  private_subnet_tags = {
    Tier = "Private"
    Purpose = "Private resources"
  }
  
  database_subnet_tags = {
    Tier = "Database"
    Purpose = "Database resources"
  }
  
  tgw_tags = {
    Purpose = "Transit Gateway"
  }
  
  internet_gateway_tags = {
    Purpose = "Internet Gateway"
  }
  
  nat_gateway_tags = {
    Purpose = "NAT Gateway"
  }
  
  network_acl_tags = {
    Purpose = "Network ACL"
  }
  
  dhcp_options_tags = {
    Purpose = "DHCP Options"
  }
  
  flow_log_tags = {
    Purpose = "Flow Logs"
  }
} 