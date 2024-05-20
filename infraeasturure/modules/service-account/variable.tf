variable "service_account_name" {}
variable "service_account_id" {
  default = ""
}
variable "time_rotating" {
  default = 90
}
variable "create_key" {
  default = true
}

variable "export_service_account_json" {
  default = true
}