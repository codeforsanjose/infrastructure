// resource "aws_service_discovery_service" "sd_service" {
//   name = local.envname

//   dns_config {
//     namespace_id = var.service_discovery_id

//     dns_records {
//       ttl  = 10
//       type = "SRV"
//     }

//     routing_policy = "MULTIVALUE"
//   }

//   health_check_custom_config {
//     failure_threshold = 1
//   }
// }