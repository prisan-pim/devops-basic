terraform {
  backend "s3" {
    bucket  = ""
    key     = ".tfstate"
    region  = "ap-southeast-1"
    profile = ""
  }
}
