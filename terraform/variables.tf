variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
  default     = "europe-west1"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "masterclass"
}

variable "runtime_template_name" {
  description = "Name of the Colab Enterprise runtime template"
  type        = string
  default     = "default"
}

variable "runtime_template_display_name" {
  description = "Display Name of the Colab Enterprise runtime template"
  type        = string
  default     = "Default"
}

variable "machine_type" {
  description = "The machine type for the Colab Enterprise runtime"
  type        = string
  default     = "e2-standard-4"
}

variable "notebook_bucket_name" {
  description = "Name of the notebook bucket"
  type        = string
}

variable "runtime_owner" {
  description = "Email of the user who will own the runtime"
  type        = string
  default     = "" # No default, must be specified in terraform.tfvars
}
