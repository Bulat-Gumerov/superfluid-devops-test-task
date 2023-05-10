namespace = "superfluid-sentinel"
name = "superfluid-sentinel-service-task"
stage = "dev"
delimiter = "-"
attributes = []
tags = [
  "Environment" = "dev",
  "Name" = "superfluid-sentinel",
  "ManagedBy" = "terraform",
]
vpc_cidr_block = "172.16.0.0/16"
ecs_launch_type = "FARGATE"
network_mode = "awsvpc"
container_name = "superfluid-sentinel"
container_image = "superfluidfinance/superfluid-sentinel:latest"
container_memory = 512
container_memory_reservation = 256
container_cpu = 256
container_port_mappings = [
  {
    containerPort = 80
    hostPort      = 80
    protocol      = "tcp"
  },
  {
    containerPort = 9100
    hostPort      = 9100
    protocol      = "tcp"
  }
]
