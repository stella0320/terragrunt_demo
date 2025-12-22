data "aws_region" "current" {
  
}

resource "aws_vpc_endpoint" "this" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.region}.sqs"

  subnet_ids = var.subnet_ids
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  security_group_ids = [var.security_group_id]
    tags = merge(
    {
        "Name" = "${var.project_name}-sqs-interface-endpoint"
    },
        var.tags,
    )
}
