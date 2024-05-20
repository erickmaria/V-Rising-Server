
variable "name" {}
variable "description" {
  default = ""
}
variable "network_name" {}
variable "priority" {}
variable "direction" {}
variable "action" {}
variable "target_tags" {
  type = list(string)
  default = []
}

variable "source_ranges" { 
  type =  list(string)
  default = []
}

variable "destination_ranges" { 
  type =  list(string) 
  default = []
}

variable "rules" {
  type = list(object({
    ports    = list(string),
    protocol = string
  }))
}