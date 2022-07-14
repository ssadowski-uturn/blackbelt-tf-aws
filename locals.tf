locals {
  local_tags = {
    Created = timestamp() // make sure resources include lifecycle - ignore_changes tags["Created"]
  }
  tags = merge(var.default_tags, local.local_tags)

  ignore_changes = ["Created"]

  #ingress_whitelist = []
  #ingress_ips       = concat(["${var.local_egress}/32"], local.ingress_whitelist)

  certificate_arns = [
    "arn:aws:acm:us-west-2:172491387323:certificate/2a863bc8-9a5e-47a7-930d-575b2a9a3076" // capstone.clyx.io cert
  ]

  ecs_secrets = [{
    name      = "WORDPRESS_DB_NAME",
    valueFrom = "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lp_prod/WORDPRESS_DB_NAME"
    },
    {
      name      = "WORDPRESS_DB_USER",
      valueFrom = "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lp_prod/WORDPRESS_DB_USER"
    },
    {
      name      = "WORDPRESS_DB_PASSWORD"
      valueFrom = "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lp_prod/WORDPRESS_DB_PASSWORD"
    },
    {
      name      = "WORDPRESS_DB_HOST",
      valueFrom = "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lp_prod/WORDPRESS_DB_HOST"
    }

  ]

  ecs_secrets_json = jsonencode(local.ecs_secrets)

  region     = "us-west-2"
  account_id = "172491387323"

  capstone_home_network = "10.128.0.0/23"

  host_header_fqdn = "capstone.clyx.io"
}