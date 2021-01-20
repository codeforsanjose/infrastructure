// Certificate was created manually, because we don't want Terraform to create/delete certifates unnecessarily.
// Creating a new certificate requires DNS Domain Validatio, which is currently handled manually
data "aws_acm_certificate" "issued" {
  domain   = "*.codeforsanjose.org"
  statuses = ["ISSUED"]
}
