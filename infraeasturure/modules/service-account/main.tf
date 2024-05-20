resource "google_service_account" "this" {
  display_name = var.service_account_name
  account_id = var.service_account_id == "" ? lower(replace(var.service_account_name, " ", "-")) : var.service_account_id
}

# note this requires the terraform to be run regularly
resource "time_rotating" "this" {
  rotation_days = var.time_rotating
}

resource "google_service_account_key" "this" {
  count = var.create_key ? 1 : 0
  service_account_id = google_service_account.this.name

  keepers = {
    rotation_time = time_rotating.this.rotation_rfc3339
  }
}

resource "local_file" "service_account_key" {
  count = var.export_service_account_json ? 1 : 0
    content  = base64decode(google_service_account_key.this[0].private_key)
    filename = "serviceaccount.json"
}