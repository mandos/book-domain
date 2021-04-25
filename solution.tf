module "web_pages_storage" {
  source = "./modules/s3"
}

module "web_pages_provider" {
  source = "./modules/web_pages_provider"

  s3_bucket = module.web_pages_storage.s3_bucket
}
