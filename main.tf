data "aws_region" "current" {}

resource "random_string" "stack_id" {
  length  = 8
  upper   = true
  lower   = false
  number  = false
  special = false
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${random_string.stack_id.result}"
  cidr = "10.0.0.0/16"

  azs              = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  database_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.10.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    StackId     = random_string.stack_id.result
  }
}
