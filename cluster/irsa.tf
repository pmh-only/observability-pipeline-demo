resource "aws_iam_policy" "fluentd" {
  name = "project-policy-fluentd"
  policy = data.aws_iam_policy_document.fluentd.json  
}

data "aws_iam_policy_document" "fluentd" {
  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"]
  }
}

module "irsa" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "${var.project_name}-role-fluentd"

  role_policy_arns = {
    policy = aws_iam_policy.fluentd.arn
  }

  oidc_providers = {
    cluster-oidc-provider = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "default:fluentd"
      ]
    }
  }
}
