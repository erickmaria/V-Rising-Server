resource "google_compute_network" "this" {
  name                    = "vpc-${var.network_name}"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "this" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnetwork_ip_cidr_range
  region        = var.subnetwork_region
  network       = google_compute_network.this.id

   depends_on = [ google_compute_network.this ]
}

module "default_egress_allow_all" {
  source = "../firewall"
  
  name = "v-rising-server-allow-all"
  direction = "EGRESS"
  priority = 1000
  network_name = google_compute_network.this.name
  action = "allow"

  destination_ranges = ["0.0.0.0/0"]
  rules = [{
    ports = []
    protocol = "TCP"
  },{
    ports = []
    protocol = "UDP"
  }]

  depends_on = [ 
    google_compute_network.this,
    google_compute_subnetwork.this
  ]

}

module "default_ingress_allow_ssh" {
  source = "../firewall"
  
  name = "v-rising-server-allow-ssh"
  direction = "INGRESS"
  priority = 1000
  network_name = google_compute_network.this.name
  action = "allow"
  
  source_ranges = ["0.0.0.0/0"]
  rules = [{
      ports = [22]
      protocol = "TCP"
  }]

  depends_on = [ 
    google_compute_network.this,
    google_compute_subnetwork.this
  ]

}