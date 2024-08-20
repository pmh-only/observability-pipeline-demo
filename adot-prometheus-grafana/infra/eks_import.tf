data "aws_eks_cluster" "example" {
  name = "${var.project_name}-cluster"
}
