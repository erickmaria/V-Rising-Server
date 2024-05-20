variable "bucket_name" {}
variable "bucket_location" {}
variable "public_access_prevention" {
  default = "enforced"
}
variable "bucket_iam_member" {}