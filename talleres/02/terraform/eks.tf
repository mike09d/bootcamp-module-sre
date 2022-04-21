# IAM ROLE

resource "aws_iam_role" "eks_cluster_role" {
  count = local.environment == "eks" ? 1 : 0
  name                  = "eks-cluster-role-${var.environment}"
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

resource "aws_iam_role" "eks_node_group_role" {
  count = local.environment == "eks" ? 1 : 0
  name                  = "eks-node-group-role-${var.environment}"
  force_detach_policies = true

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}



resource "aws_iam_policy" "AmazonEKSClusterCloudWatchMetricsPolicy" {
  count = local.environment == "eks" ? 1 : 0
  name   = "AmazonEKSClusterCloudWatchMetricsPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "AmazonEKSClusterNLBPolicy" {
  count = local.environment == "eks" ? 1 : 0
  name   = "AmazonEKSClusterNLBPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "elasticloadbalancing:*",
                "ec2:CreateSecurityGroup",
                "ec2:Describe*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  count = local.environment == "eks" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  count = local.environment == "eks" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCloudWatchMetricsPolicy" {
  count = local.environment == "eks" ? 1 : 0
  policy_arn = aws_iam_policy.AmazonEKSClusterCloudWatchMetricsPolicy[0].arn
  role       = aws_iam_role.eks_cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCluserNLBPolicy" {
  count = local.environment == "eks" ? 1 : 0
  policy_arn = aws_iam_policy.AmazonEKSClusterNLBPolicy[0].arn
  role       = aws_iam_role.eks_cluster_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  count = local.environment == "eks" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  count = local.environment == "eks" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role[0].name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  count = local.environment == "eks" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role[0].name
}


# EKS CLUSTER

resource "aws_eks_cluster" "main" {
  count = local.environment == "eks" ? 1 : 0
  name     = "${var.cluster_name_eks}-${var.environment}"
  role_arn = aws_iam_role.eks_cluster_role[0].arn

  //enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  enabled_cluster_log_types = []

  vpc_config {
    subnet_ids = data.aws_subnet_ids.private.ids
  }

  timeouts {
    delete = "30m"
  }

  depends_on = [
    aws_cloudwatch_log_group.eks_cluster,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}

resource "aws_cloudwatch_log_group" "eks_cluster" {
  count = local.environment == "eks" ? 1 : 0
  name              = "/aws/eks/${var.cluster_name_eks}-${var.environment}/cluster"
  retention_in_days = 30

  tags = {
    Name        = "${var.cluster_name_eks}-${var.environment}-eks-cloudwatch-log-group"
  }
}


resource "aws_eks_node_group" "eks_node_group" {
  count = local.environment == "eks" ? 1 : 0
  cluster_name    = aws_eks_cluster.main[0].name
  node_group_name = "${var.cluster_name_eks}-${var.environment}-node_group"
  node_role_arn   = aws_iam_role.eks_node_group_role[0].arn
  subnet_ids      = data.aws_subnet_ids.private.ids
  disk_size = var.disk_size
  force_update_version = true

  scaling_config {
    desired_size = 4
    max_size     = 6
    min_size     = 4
  }

  instance_types  = [var.eks_node_group_instance_types]

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


data "tls_certificate" "auth" {
  count = local.environment == "eks" ? 1 : 0
  url = aws_eks_cluster.main[0].identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "main" { 
  count = local.environment == "eks" ? 1 : 0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.auth[0].certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main[0].identity[0].oidc[0].issuer
    depends_on = [ aws_eks_node_group.eks_node_group ]
  lifecycle {
    ignore_changes = [thumbprint_list]
  }
}