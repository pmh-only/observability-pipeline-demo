data "aws_eks_cluster" "example" {
  name = "${var.project_name}-cluster"
}

data "aws_iam_openid_connect_provider" "oidc" {
  url = data.aws_eks_cluster.example.identity[0].oidc[0].issuer
}
