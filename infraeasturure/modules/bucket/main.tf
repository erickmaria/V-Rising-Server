resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = var.bucket_location

  public_access_prevention =var.public_access_prevention
}

resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.this.name
  role = "roles/storage.admin"
  member = var.bucket_iam_member

  depends_on = [ google_storage_bucket.this ]
}