[
  {
    "name": "${task_name}",
    "image": "${container_image}",
    "cpu": ${container_cpu},
    "memory": ${container_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "capstone-group",
          "awslogs-region": "${aws_region}",
          "awslogs-create-group": "true",
          "awslogs-stream-prefix": "ecs"
        }
    },
    ${envvars}
    ${secrets}
    ${mountpoints}
    "portMappings": [
      {
        "containerPort": ${app_port}
      }
    ]
  }
]
