resource "aws_s3_bucket" "backend" {
  bucket = "${terraform.workspace}-terraform-bucket-2025-1202"
}
