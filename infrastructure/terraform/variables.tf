variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "domain_name" {
  description = "The root domain name (e.g. example.com)"
  type        = string
}

variable "website_subdomain" {
  description = "Subdomain for the static site"
  type        = string
  default     = "zerohours"
}