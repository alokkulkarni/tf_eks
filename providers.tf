terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57.0"
    }

    awscc = {
      source  = "hashicorp/awscc"
      version = "1.4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "4.3.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "awscc" {
  region  = var.region
  profile = var.profile
}

provider "kubernetes" {
  config_path            = "~/.kube/config"
  host                   = aws_eks_cluster.my_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.my_eks_cluster.certificate_authority.0.data)
}

provider "helm" {
  kubernetes {
    config_path            = "~/.kube/config"
    host                   = aws_eks_cluster.my_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.my_eks_cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.my_eks_cluster.id]
      command     = "aws"
    }
  }
}

provider "random" {}

provider "tls" {}

provider "vault" {
  address = "http://"
}

provider "kubectl" {
  config_path            = "~/.kube/config"
  load_config_file       = false
  host                   = aws_eks_cluster.my_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.my_eks_cluster.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.my_eks_cluster.id]
    command     = "aws"
  }
}