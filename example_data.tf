locals {
  domains = [
    "foo1.boo.pl",
    "foo2.boo.pl",
    "moo.net",
  ]
}

resource "aws_s3_bucket_object" "web_page" {
  for_each = toset(local.domains)

  bucket  = module.web_pages_storage.s3_bucket.id
  key     = "${each.value}/index.html"
  content = templatefile(
    "${path.module}/templates/index.html.tpl",
    {
      domain = each.value
    }
  )
  content_type = "text/html"
}
