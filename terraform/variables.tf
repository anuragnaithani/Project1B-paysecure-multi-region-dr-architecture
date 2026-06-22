variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "dr_region" {
  description = "Disaster recovery AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "primary_api_domain" {
  description = "Primary API domain for health checks"
  type        = string
  default     = "api.paysecure.example.com"
}
