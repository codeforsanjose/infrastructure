output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "ecs_asg_arn" {
  value = module.asg.this_autoscaling_group_arn
}
