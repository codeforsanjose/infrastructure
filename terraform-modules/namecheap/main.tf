// https://github.com/adamdecaf/terraform-provider-namecheap
# For example, restrict namecheap version to 1.5.0
provider "namecheap" {
  version = "~> 1.5"
}

# Create a DNS A Record for a domain you own
resource "namecheap_record" "www-example-com" {
  name = "www"
  domain = "example.com"
  address = "127.0.0.1"
  mx_pref = 10
  type = "A"
}