module "web_pages_storage" {
  source = "./modules/storage"

  cloudfront_origin_access_identity = module.web_pages_provider.cloudfront_origin_access_identity
}

module "web_pages_provider" {
  source = "./modules/web_pages_provider"

  s3_bucket = module.web_pages_storage.s3_bucket
}
