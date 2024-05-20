resource "google_compute_firewall" "this" {
  name        = var.name
  network     = var.network_name
  description = var.description 
  direction   = var.direction
  priority    = var.priority

  target_tags = var.target_tags
  source_ranges = var.source_ranges
  destination_ranges = var.destination_ranges

  dynamic "allow" {
    for_each = [for rule in var.rules : rule if var.action == "allow"]
    iterator = rule
    content {
      ports    = rule.value.ports
      protocol = rule.value.protocol
    }
  }

  dynamic "deny" {
    for_each = [for rule in var.rules : rule if var.action == "deny"]
    iterator = rule
    content {
      ports    = rule.value.ports
      protocol = rule.value.protocol
    }
  }

}