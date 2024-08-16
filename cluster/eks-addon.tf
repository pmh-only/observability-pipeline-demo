module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      configuration_values = jsonencode({
        controller = {
          tolerations = [{
            effect   = "NoSchedule"
            key      = "dedicated"
            operator = "Equal"
            value    = "addon"
          }]
        }
      })
    }
    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        tolerations = [{
          effect   = "NoSchedule"
          key      = "dedicated"
          operator = "Equal"
          value    = "addon"
        }]
      })
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  enable_karpenter = true
  karpenter = {
    values = [
      <<EOF
        tolerations:
          - key: dedicated
            operator: Equal
            value: addon
            effect: NoSchedule
      EOF
    ]
  }
  
  enable_metrics_server = true
  metrics_server = {
    values = [
      <<EOF
        tolerations:
          - key: dedicated
            operator: Equal
            value: addon
            effect: NoSchedule
      EOF
    ]
  }
}
