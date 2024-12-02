terraform {
  backend "s3" {
    bucket = "eks-cluster-terra-state-secondary"
    key    = "terraform/terraform.tfstate"
    region = "us-west-2"
  }
}