output "external_ip" {
  value = aws_ecs_service.primary.network_configuration
}