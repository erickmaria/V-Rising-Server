output "service_account_name" {
  value = google_service_account.this.name
}

output "service_account_id" {
  value = google_service_account.this.id
}

output "service_account_email" {
  value = google_service_account.this.email
}

output "service_account_key" {
  value = google_service_account_key.this
  sensitive = true
}