data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "www" {
  for_each = toset(var.host_names)

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = "300"
  records = [var.alb_external_dns]
}

// Can link DNS Record to ALB via Alias, however not required
// resource "aws_route53_record" "www" {
//   zone_id = "${data.aws_route53_zone.selected.zone_id}"
//   name    = "${var.domain_name}"
//   type    = "A"
//   alias {
//     name                   = "${aws_lb.my-test-lb.dns_name}"
//     zone_id                = "${aws_lb.my-test-lb.zone_id}"
//     evaluate_target_health = false
//   }
// }