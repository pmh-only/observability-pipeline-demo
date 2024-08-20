resource "aws_eks_addon" "addon" {
  addon_name = "adot"
  cluster_name = data.aws_eks_cluster.example.name

  configuration_values = jsonencode({
    collector = {
      prometheusMetrics = {
        exporters = {
          prometheusremotewrite = {
            endpoint = "${module.prometheus.workspace_prometheus_endpoint}api/v1/remote_write"
          }
        }
        pipelines = {
          metrics = {
            amp = {
              enabled = true
            }
            emf = {
              enabled = false
            }
          }
        }
        resources = {
          limits = {
            cpu = "1000m",
            memory = "750Mi"
          }
          requests = {
            cpu = "300m",
            memory = "512Mi"
          }
        }
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.caller.account_id}:role/${var.project_name}-role-prometheus"
          }
        }
      }
    }
    tolerations = [{
      key      = "dedicated"
      value    = "addon"
    }]
  })
}

resource "helm_release" "cert-manager" {
  repository = "https://charts.jetstack.io"
  chart = "cert-manager"

  name = "cert-manager"
  namespace = "cert-manager"

  create_namespace = true

  values = [jsonencode({
    crds = {
      enabled = true
    }
    tolerations = [{
      effect   = "NoSchedule"
      key      = "dedicated"
      operator = "Equal"
      value    = "addon"
    }]
    webhook = {
      tolerations = [{
        effect   = "NoSchedule"
        key      = "dedicated"
        operator = "Equal"
        value    = "addon"
      }]
    }
    cainjector = {
      tolerations = [{
        effect   = "NoSchedule"
        key      = "dedicated"
        operator = "Equal"
        value    = "addon"
      }]
    }
    startupapicheck = {
      tolerations = [{
        effect   = "NoSchedule"
        key      = "dedicated"
        operator = "Equal"
        value    = "addon"
      }]
    }
  })]
}
