variable "default_tags" {
  description = "tags to apply to everything"
  type        = map(string)
  default = {
    Managed_By = "terraform"
    Owner      = "admin@meta-meta.com"
  }
}
