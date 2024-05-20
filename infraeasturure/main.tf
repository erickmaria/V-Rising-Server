
#######################################
### LOCAL VARIABLES
#######################################

locals {
  name = "v-rising-server"
  link_tags = "${local.name}"
}

#######################################
### PROVIDER SETTINGS
#######################################

provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_project_region
}


#######################################
### NETWORK SETTINGS
#######################################

module "vpc" {
  source = "./modules/network/vpc"

  network_name = "${local.name}"

  subnetwork_name = "subnet-${local.name}"
  subnetwork_ip_cidr_range = "10.2.0.0/22"
  subnetwork_region = "us-east1"
}

module "firewall" {
  source = "./modules/network/firewall"
  
  name = "${local.name}-allow-server-ports"
  direction = "INGRESS"
  priority = 1000
  network_name = module.vpc.network_name

  target_tags = [local.link_tags]
  source_ranges = ["0.0.0.0/0"]
  action = "allow"

  rules = [{
    ports = [9876, 9877]
    protocol = "UDP"
  }]

  depends_on = [ module.vpc ]

}

#######################################
### VIRTUAL MACHINE INSTANCE SETTINGS
#######################################

module "instance" {
  source = "./modules/instances"

  name = "${local.name}"

  network_interface_subnetwork = module.vpc.subnetwork_id

  # network tags
  tags = [local.link_tags]

  depends_on = [ 
    module.vpc,
    module.firewall,
  ]
}

#######################################
### SERVICE ACCOUNT SETTINGS
#######################################

module "service_account" {
  source = "./modules/service-account"
  service_account_name = "sa-${local.name}"
}

#######################################
### BUCKET SETTINGS
#######################################

module "bucket" {
  source = "./modules/bucket"

  bucket_name = "bckt-${local.name}"
  bucket_location = "US"

  bucket_iam_member = "serviceAccount:${module.service_account.service_account_email}"

  depends_on = [ module.service_account ]
}
