terraform {
  backend "s3" {
    bucket  = "infratraining"
    key     = "eks-training.tfstate"
    region  = "ap-southeast-1"
    profile = "devops"
  }
}
