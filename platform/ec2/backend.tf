terraform {
  backend "s3" {
    bucket  = "infratraining"
    key     = "ec2-training.tfstate"
    region  = "ap-southeast-1"
    profile = "devops"
  }
}
