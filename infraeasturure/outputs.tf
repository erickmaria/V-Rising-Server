output "instance_public_address" {
  value = module.instance.instance_public_address
}

output "bucket_url" {
  value = module.bucket.bucket_url
}

output "service_account_id" {
  value = module.service_account.service_account_id
}

output "service_account_key" {
  value = module.service_account.service_account_key
  sensitive = true
}