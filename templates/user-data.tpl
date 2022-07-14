#!/usr/bin/env bash
sudo mkdir -p /etc/ecs
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
sudo amazon-linux-extras disable docker
sudo amazon-linux-extras install -y ecs
sudo yum install amazon-efs-utils -y
sudo systemctl enable ecs
sudo systemctl enable amazon-ecs-volume-plugin
sudo yum update -y
sudo reboot