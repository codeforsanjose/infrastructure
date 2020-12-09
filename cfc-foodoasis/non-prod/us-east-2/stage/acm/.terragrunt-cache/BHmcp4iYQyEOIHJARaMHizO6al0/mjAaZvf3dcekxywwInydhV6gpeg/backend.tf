terraform {
  backend "s3" {
    bucket = "codeforcalifornia"
    key    = "terraform-state/foodoasis/dev/terraform.tfstate"
    region = "us-west-1"
    dynamodb_table = "terraform-locks"
  }
}
