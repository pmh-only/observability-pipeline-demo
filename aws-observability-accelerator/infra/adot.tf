module "eks_monitoring" {
  source = "github.com/aws-observability/terraform-aws-observability-accelerator//modules/eks-monitoring"

  eks_cluster_id = data.aws_eks_cluster.example.name

  enable_amazon_eks_adot = true
  enable_cert_manager = false
  enable_apiserver_monitoring = true

  enable_external_secrets = true
  grafana_api_key         = module.managed_grafana.workspace_api_keys.admin.key
  target_secret_name      = "grafana-admin-credentials"
  target_secret_namespace = "grafana-operator"
  grafana_url             = "https://${module.managed_grafana.workspace_endpoint}"

  enable_dashboards = true
  enable_managed_prometheus       = false
  managed_prometheus_workspace_id = module.prometheus.workspace_id

  enable_alertmanager = true

  prometheus_config = {
    global_scrape_interval = "60s"
    global_scrape_timeout  = "15s"
  }

  enable_logs = true

  ne_config = {
    helm_settings = {
      "tolerations[0].operator" = "Exists"
    }
  }
}
