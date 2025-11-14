variable "project" {
  description = "GCP project id"
  type        = string
  default     = "shailaja-477403"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "cloud_run_service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "my-backend-service"
}
