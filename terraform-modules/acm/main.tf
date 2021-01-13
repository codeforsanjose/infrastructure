data "aws_acm_certificate" "issued" {
  domain   = "*.codeforsanjose.com"
  statuses = ["ISSUED"]
}

// TODO: Use codeforsanjose.org
// Use namecheap provider