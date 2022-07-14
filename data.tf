data "aws_vpc" "main-ecs-vpc" {
  id = "vpc-03af3e08842ffd930"
}

data "aws_nat_gateway" "ecs-nat-gateway" {
  id = "nat-0a8e6dec08bcea395"
}

data "aws_subnet" "private_usw2a" {
  id = "subnet-05d3cd485706f4cfe"
}

data "aws_subnet" "private_usw2b" {
  id = "subnet-0bcff7f2459bcc8b2"
}

data "aws_subnet" "private_usw2c" {
  id = "subnet-03e6156e133f7f0fe"
}

data "aws_subnet" "public_usw2a" {
  id = "subnet-08e35e3c6eeb8ea8d"
}

data "aws_subnet" "public_usw2b" {
  id = "subnet-066c44235f3300538"
}

data "aws_subnet" "public_usw2c" {
  id = "subnet-07ff9d0154dbc307f"
}