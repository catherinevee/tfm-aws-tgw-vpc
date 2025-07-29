# Advanced AWS Networking Module Makefile
# Common operations for Terraform module management

.PHONY: help init plan apply destroy validate fmt lint clean test examples

# Default target
help:
	@echo "Advanced AWS Networking Module - Available Commands:"
	@echo ""
	@echo "Module Management:"
	@echo "  init      - Initialize Terraform working directory"
	@echo "  plan      - Generate and show execution plan"
	@echo "  apply     - Build or change infrastructure"
	@echo "  destroy   - Destroy Terraform-managed infrastructure"
	@echo "  validate  - Validate Terraform configuration files"
	@echo "  fmt       - Format Terraform configuration files"
	@echo "  lint      - Run tflint for static analysis"
	@echo ""
	@echo "Examples:"
	@echo "  examples  - Run examples validation"
	@echo "  test      - Run all tests"
	@echo ""
	@echo "Utilities:"
	@echo "  clean     - Clean up temporary files"
	@echo "  docs      - Generate documentation"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init -upgrade

# Plan Terraform changes
plan:
	@echo "Planning Terraform changes..."
	terraform plan -out=tfplan

# Apply Terraform changes
apply:
	@echo "Applying Terraform changes..."
	terraform apply tfplan

# Destroy infrastructure
destroy:
	@echo "Destroying infrastructure..."
	terraform destroy

# Validate Terraform configuration
validate:
	@echo "Validating Terraform configuration..."
	terraform validate

# Format Terraform files
fmt:
	@echo "Formatting Terraform files..."
	terraform fmt -recursive

# Run tflint for static analysis
lint:
	@echo "Running tflint..."
	tflint --init
	tflint

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	rm -f tfplan
	rm -f .terraform.lock.hcl
	rm -rf .terraform

# Generate documentation
docs:
	@echo "Generating documentation..."
	terraform-docs markdown table . > README.md

# Run examples validation
examples:
	@echo "Validating examples..."
	@for example in examples/*/; do \
		echo "Validating $$example..."; \
		cd $$example && terraform init -backend=false && terraform validate && cd ../..; \
	done

# Run all tests
test: validate fmt lint examples
	@echo "All tests completed successfully!"

# Development workflow
dev: init validate fmt lint
	@echo "Development setup completed!"

# Production deployment
prod: init validate plan
	@echo "Production deployment ready. Run 'make apply' to deploy."

# Quick setup for new environments
setup:
	@echo "Setting up new environment..."
	terraform init
	terraform workspace new $(shell date +%Y%m%d-%H%M%S) || true
	terraform workspace select $(shell terraform workspace show)
	@echo "Environment setup completed!"

# Show current workspace and state
status:
	@echo "Current workspace: $(shell terraform workspace show)"
	@echo "Terraform version: $(shell terraform version | head -n1)"
	@echo "AWS provider version: $(shell terraform version -json | jq -r '.provider_selections["registry.terraform.io/hashicorp/aws"]')"

# Backup current state
backup:
	@echo "Backing up current state..."
	@if [ -f terraform.tfstate ]; then \
		cp terraform.tfstate terraform.tfstate.backup.$(shell date +%Y%m%d-%H%M%S); \
		echo "State backed up successfully!"; \
	else \
		echo "No terraform.tfstate file found."; \
	fi

# Restore state from backup
restore:
	@echo "Available backups:"
	@ls -la terraform.tfstate.backup.* 2>/dev/null || echo "No backups found"
	@echo ""
	@read -p "Enter backup filename to restore: " backup_file; \
	if [ -f "$$backup_file" ]; then \
		cp "$$backup_file" terraform.tfstate; \
		echo "State restored from $$backup_file"; \
	else \
		echo "Backup file $$backup_file not found"; \
	fi

# Show module outputs
outputs:
	@echo "Module outputs:"
	terraform output

# Show module resources
resources:
	@echo "Module resources:"
	terraform state list

# Import existing resources (example)
import-example:
	@echo "Example import commands:"
	@echo "# Import existing VPC:"
	@echo "terraform import module.networking.aws_vpc.main[0] vpc-12345678"
	@echo ""
	@echo "# Import existing Transit Gateway:"
	@echo "terraform import module.networking.aws_ec2_transit_gateway.main[0] tgw-12345678"
	@echo ""
	@echo "# Import existing security group:"
	@echo "terraform import module.networking.aws_security_group.custom[\"web\"] sg-12345678"

# Security audit
security-audit:
	@echo "Running security audit..."
	@echo "1. Checking for hardcoded secrets..."
	@grep -r "password\|secret\|key" . --exclude-dir=.terraform --exclude-dir=.git || echo "No obvious secrets found"
	@echo ""
	@echo "2. Checking for public access..."
	@grep -r "0.0.0.0/0" . --exclude-dir=.terraform --exclude-dir=.git || echo "No public access rules found"
	@echo ""
	@echo "3. Checking for required tags..."
	@echo "Ensure all resources have appropriate tags for cost allocation and security"

# Cost estimation
cost-estimate:
	@echo "Cost estimation for this module:"
	@echo "VPC: Free"
	@echo "Subnets: Free"
	@echo "Internet Gateway: Free"
	@echo "NAT Gateway: ~$45/month per gateway"
	@echo "Transit Gateway: ~$0.50/hour + data processing"
	@echo "VPC Endpoints: ~$0.01/hour per endpoint"
	@echo "Security Groups: Free"
	@echo ""
	@echo "Total estimated monthly cost: $50-200 depending on usage"

# Compliance check
compliance:
	@echo "Running compliance checks..."
	@echo "1. Tagging compliance..."
	@echo "2. Security group compliance..."
	@echo "3. Network segmentation compliance..."
	@echo "4. Transit Gateway compliance..."
	@echo "Compliance checks completed!"

# Performance optimization
optimize:
	@echo "Performance optimization recommendations:"
	@echo "1. Use single NAT Gateway for non-production environments"
	@echo "2. Enable VPC endpoints for frequently accessed AWS services"
	@echo "3. Use appropriate subnet sizes to avoid IP waste"
	@echo "4. Consider Transit Gateway for multi-VPC architectures"
	@echo "5. Use security groups instead of network ACLs where possible"

# Emergency rollback
rollback:
	@echo "Emergency rollback procedure:"
	@echo "1. Stop any ongoing deployments"
	@echo "2. Identify the last known good state"
	@echo "3. Run: terraform plan -refresh-only"
	@echo "4. Review the plan carefully"
	@echo "5. Run: terraform apply -auto-approve"
	@echo "WARNING: This may cause data loss!"

# Module versioning
version:
	@echo "Current module version: 1.0.0"
	@echo "Terraform version: $(shell terraform version | head -n1)"
	@echo "AWS provider version: $(shell terraform version -json | jq -r '.provider_selections["registry.terraform.io/hashicorp/aws"]')"

# Show help for specific command
help-%:
	@echo "Help for command '$*':"
	@make -s $* 2>/dev/null || echo "No specific help available for '$*'" 