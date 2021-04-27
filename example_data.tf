locals {
  domain_folders = {
    "foo1.boo.pl" = "domain1"
    "foo2.boo.pl" = "domain2"
    "moo.net"     = "domain3"
  }
}

resource "aws_s3_bucket_object" "web_page" {
  for_each = local.domain_folders

  bucket = module.web_pages_storage.s3_bucket.id
  key    = "${each.value}/index.html"
  content = templatefile(
    "${path.module}/templates/index.html.tpl",
    {
      domain = each.key
    }
  )
  content_type = "text/html"
}

resource "aws_dynamodb_table_item" "domain_folders" {
  for_each = local.domain_folders

  table_name = module.domain_service.dynamodb.name
  hash_key   = module.domain_service.dynamodb.hash_key

  item = <<ITEM
{
  "fqdn": {"S": "${each.key}"},
  "folder": {"S": "${each.value}"}
}
ITEM
}
