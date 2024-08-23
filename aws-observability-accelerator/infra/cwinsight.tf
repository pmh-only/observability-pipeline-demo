module "eks_container_insights" {
  source = "github.com/aws-observability/terraform-aws-observability-accelerator//modules/eks-container-insights"

  most_recent = true
  kubernetes_version = data.aws_eks_cluster.example.version
  eks_cluster_id = data.aws_eks_cluster.example.name
  eks_oidc_provider_arn = data.aws_iam_openid_connect_provider.oidc.arn
}
