# IAM Role for the EKS Cluster
resource "aws_iam_role" "cluster-role1" {
  name = "cluster-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to the cluster role
resource "aws_iam_role_policy_attachment" "cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role1.name
}

# IAM Role for the EKS Node Group
resource "aws_iam_role" "node-role1" {
  name = "node-role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to the node role
resource "aws_iam_role_policy_attachment" "node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-role1.name
}

resource "aws_iam_role_policy_attachment" "cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  # Updated policy ARN
  role       = aws_iam_role.node-role1.name
}

resource "aws_iam_role_policy_attachment" "registry-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-role1.name
}

# EKS Cluster
resource "aws_eks_cluster" "eks-cluster1" {
  name     = "k8-cluster1"
  role_arn = aws_iam_role.cluster-role.arn
  version  = "1.30"

  vpc_config {
    subnet_ids         = ["subnet-05eb6d053b4d88eb0", "subnet-04b784912094c53b9"]
    security_group_ids = ["sg-031e0d009b22126a2"]
  }

  depends_on = [aws_iam_role_policy_attachment.cluster-policy]
}

# EKS Node Group
resource "aws_eks_node_group" "k8-cluster-node-group1" {
  cluster_name    = aws_eks_cluster.eks-cluster1.name
  node_group_name = "k8-cluster-node-group1"
  node_role_arn   = aws_iam_role.node-role.arn
  subnet_ids      = ["subnet-05eb6d053b4d88eb0", "subnet-04b784912094c53b9"]

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 5
  }

  depends_on = [aws_iam_role_policy_attachment.node-policy]
}
