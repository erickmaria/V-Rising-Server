variable "name" {}

variable "machine_type" {
    default = "e2-standard-2"
}

variable "zone" {
    default = ""
}

variable "image" {
    default = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240112"
}
variable "disk_size" {
    default = 20
}

variable "network_tier" {
    default = "PREMIUM"
}

variable "network_interface_subnetwork" {}

variable "network_interface_nic_type" {
    default = "GVNIC"
}

variable "network_interface_stack_type" {
    default = "IPV4_ONLY"
}

variable "tags" {
  type = set(string)
}

variable "public_access_enabled" {
    type = bool
    default = true
}