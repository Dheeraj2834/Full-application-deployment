terraform {
  backend "s3" {
    bucket       = "dheerajdheeraj"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"

    encrypt      = true
    use_lockfile = true
  }
}