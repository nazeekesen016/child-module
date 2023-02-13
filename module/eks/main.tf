# terraform {
#   required_version = ">= 1.1.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-2"
# }
resource "aws_eks_cluster" "eks" {
  name     = "name"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.24"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = var.private-subnet-id
    security_group_ids      = [aws_security_group.valueforcluster.id]
  }


  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    # aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    # aws_iam_role.eks_cluster,
  ]
}

resource "aws_iam_role" "eks_cluster" {
  name = "cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}


resource "aws_eks_node_group" "nodes_general" {
  for_each     = local.node_group
  cluster_name = aws_eks_cluster.eks.name

  node_group_name = each.value

  node_role_arn = aws_iam_role.workernodes.arn

  subnet_ids = var.private-subnet-id



  # launch_template {
  #   id      = aws_launch_template.template.id
  #   version = aws_launch_template.template.latest_version

  # }
  # # ami_type = each.value
  # capacity_type = "ON_DEMAND"

  # # id      = aws_launch_template.template.id
  # # version = "$Latest"


  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }


  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"

  launch_template {
    name    = aws_launch_template.template.name
    version = aws_launch_template.template.latest_version

  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    # aws_iam_role_policy_attachment.
  ]
}

resource "aws_launch_template" "template" {
  name = "terraform"

  tags = {
    Name = "instance"
  }
}

resource "aws_iam_role" "workernodes" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.workernodes.name
}



# resource "aws_security_group" "value" {
#   name   = var.sg-name
#   vpc_id = var.vpc_id

#   dynamic "ingress" {
#     for_each = [0]
#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#   dynamic "egress" {
#     for_each = [0]
#     content {
#       from_port   = egress.value
#       to_port     = egress.value
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }

#   }
# }


resource "aws_security_group" "valueforcluster" {
  name   = "terraf1"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = [0]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = [0]
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}
