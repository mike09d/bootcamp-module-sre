# FARGATE

- main.tf

```
resource "aws_eks_fargate_profile" "eks_fargate" {
  cluster_name           = "${var.cluster_name}-${var.environment}"
  fargate_profile_name   = "${var.cluster_name}-${var.fargate_namespace}-${var.environment}-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids             = var.private_subnets
  
  selector {
    namespace = var.fargate_namespace
  }
  timeouts {
    create   = "30m"
    delete   = "30m"
  }
}

resource "aws_iam_role" "eks_fargate_role" {
  name = "${var.cluster_name}-fargate_cluster_role-${var.fargate_namespace}"
  description = "Allow fargate cluster to allocate resources for running pods"
  force_detach_policies = true
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_fargate_role.name
}


resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_fargate_role.name
}
```

- variables.tf


```
variable "cluster_name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "fargate_namespace" {}
```


- Invocación del modulo


```
module "fargate-devops" {
  source            = "./xpertgroup.devsecops.modules/containers/cluster/eks/fargate"
  cluster_name      = var.cluster_name
  environment       = local.environment
  fargate_namespace = "devops"
  private_subnets   = module.vpc.aws_subnets_private
}

```