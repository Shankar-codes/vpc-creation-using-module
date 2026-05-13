module "vpc" {
  source = "git::https://github.com/Shankar-codes/terraform-vpc-module.git?ref=main"

  #VPC
  vpc_cidr_block = var.vpc_cidr_block
  project_name   = var.project_name
  environment    = var.environment
  vpc_tags       = var.vpc_tags

  #public subnets
  public_subnet_cidrs = var.public_subnet_cidrs

  #private subnets
  private_subnet_cidrs = var.private_subnet_cidrs

  #database subnets
  database_subnet_cidrs = var.database_subnet_cidrs

  #vpc peering
  is_peering_required = true
}