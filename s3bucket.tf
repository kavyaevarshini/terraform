resource "aws_s3_bucket" "aws" {
  
  bucket = "${var.aws_domain_name}"

  acl    = "public-read"
  
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.aws_domain_name}/*"]
    }
  ]
}
POLICY

  
    index_document = "index.html"
    
    error_document = "404.html"
  }
}