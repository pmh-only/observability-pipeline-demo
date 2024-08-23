resource "aws_cloudwatch_log_group" "this" {
  name = "/amp/${var.project_name}-prom"
}

module "prometheus" {
  source = "terraform-aws-modules/managed-service-prometheus/aws"

  workspace_alias = "${var.project_name}-prom"
  logging_configuration = {
    log_group_arn = "${aws_cloudwatch_log_group.this.arn}:*"
  }
}
