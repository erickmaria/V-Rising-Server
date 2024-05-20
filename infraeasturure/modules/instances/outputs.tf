output "instance_id" {
    value = google_compute_instance.this.id
}

output "instance_name" {
    value = google_compute_instance.this.name
}

# output "instance_metadata" {
#     value = google_compute_instance.this.metadata
# }

output "instance_public_address" {
    value = var.public_access_enabled ?  google_compute_address.this[0].address : ""
}
