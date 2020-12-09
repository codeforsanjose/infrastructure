data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.host_name
  type    = "CNAME"
  ttl     = "300"
  records = [var.alb_external_dns]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "ssl" {
  load_balancer_arn = var.alb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    type             = "forward"
    target_group_arn = var.alb_target_group_arn
  }
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