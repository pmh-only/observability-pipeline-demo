module "managed_grafana" {
  source = "terraform-aws-modules/managed-service-grafana/aws"

  # Workspace
  name                      = "${var.project_name}-grafana"
  associate_license = false
  account_access_type       = "CURRENT_ACCOUNT"
  authentication_providers  = ["AWS_SSO"]
  permission_type           = "SERVICE_MANAGED"
  data_sources              = ["CLOUDWATCH", "PROMETHEUS", "XRAY"]
  notification_destinations = ["SNS"]

  enable_alerts = true

  role_associations = {
    "ADMIN" = {
      "user_ids" = [
        "343854d8-3051-7052-a298-e3fc9624f442"
      ]
    }
  }
}
