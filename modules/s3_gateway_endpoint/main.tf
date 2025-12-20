data "aws_region" "current" {
  
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
  tags = merge(
    {
      "Name"        = "${var.project_name}-s3-gateway-endpoint"
    },
    var.tags,
  )
}