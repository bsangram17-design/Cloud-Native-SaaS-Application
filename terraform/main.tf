provider "aws" {
  region = "ap-south-1"
}

# Standard VPC for EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "saas-vpc"
  cidr = "10.0.0.0/16"

  # Using the zones you specified
  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = "saas-cluster"
  kubernetes_version = "1.31"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # This maps to your --node-type and --nodes flags
  eks_managed_node_groups = {
    main = {
      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 2
      desired_size = 2
    }
  }
}
