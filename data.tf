data "aws_availability_zones" "available" {
  state = "available"
}

output "az" {
  value = sort(data.aws_availability_zones.available.names)
}
