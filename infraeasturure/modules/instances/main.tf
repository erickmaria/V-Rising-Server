data "google_compute_zones" "availables" {}

resource "google_compute_address" "this" {
  count = var.public_access_enabled ? 1 : 0
  name         = "ip-${var.name}"
  address_type = "EXTERNAL"
  network_tier = var.network_tier
}

resource "google_compute_instance" "this" {
  name         = "vm-${var.name}"
  machine_type = var.machine_type # 2 vCPU / 8 Memory
  zone = var.zone == "" ? data.google_compute_zones.availables.names[0] : var.zone

  boot_disk {
    device_name = var.name

    initialize_params {
      image = var.image
      size  = var.disk_size
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork  = var.network_interface_subnetwork
    nic_type = var.network_interface_nic_type
    stack_type  = var.network_interface_stack_type

    dynamic "access_config" {
      for_each = var.public_access_enabled ? [true] : []

      content {
        nat_ip       = google_compute_address.this[0].address
        network_tier = var.network_tier
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [ metadata ]
  }

}
