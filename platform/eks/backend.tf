terraform {
  backend "s3" {
    bucket  = ""
    key     = "eks-training.tfstate"
    region  = "ap-southeast-1"
    profile = ""
  }
}
