output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "service_discovery_id" {
  value = aws_service_discovery_private_dns_namespace.private_dns_ns.id
}

// output "asg_arn" {
//   value = module.asg.this_autoscaling_group_id
// }