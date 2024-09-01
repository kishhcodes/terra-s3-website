resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "krizznctrl" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "krizzctl2" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "publicacl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.krizznctrl,
    aws_s3_bucket_public_access_block.krizzctl2,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "/home/kali/Desktop/websiteee/index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "style.css"
  source = "/home/kali/Desktop/websiteee/style.css"
  acl    = "public-read"
  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "script.js"
  source = "/home/kali/Desktop/websiteee/script.js"
  acl    = "public-read"
  content_type = "application/javascript"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  depends_on = [ aws_s3_bucket_acl.publicacl ]

}