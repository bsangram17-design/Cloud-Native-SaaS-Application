provider "aws" {
  region = "ap-south-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "saas-cluster"
  
  vpc_id     = "vpc-05a566183852fd498"
  subnet_ids = ["subnet-0b5d9483c9f20dac4", "subnet-0f939c3bd6278333f"]

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
      instance_types = ["t3.micro"]
    }
  }
}
