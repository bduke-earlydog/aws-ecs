resource "aws_ecs_cluster" "primary" {
  name = "Teamspeak cluster"
}

resource "aws_ecs_task_definition" "primary" {
  family = "Teamspeak-Container"
  requires_compatibilities = ["EC2"]
  container_definitions = file("files/teamspeak.json")
  volume {
    name = "Teamspeak-Data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.primary.id
      root_directory = "/teamspeakdata"
      transit_encryption = "ENABLED"
    }
  }
}

resource "aws_ecs_service" "primary" {
  name = "Teamspeak Service"
  cluster = aws_ecs_cluster.primary.id
  task_definition = aws_ecs_task_definition.primary.arn
  scheduling_strategy = "DAEMON"
  network_configuration {
    subnets = ["${aws_subnet.primary.cidr_block}"]
    security_groups = ["${aws_security_group.primary.id}"]
    assign_public_ip = true
  }
}