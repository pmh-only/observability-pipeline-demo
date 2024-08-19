resource "helm_release" "self_prometheus" {
  name = "prometheus"
  namespace = "prometheus"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus"

  create_namespace = true

  values = [
    <<-EOF
      alertmanager:
        enabled: false

      serviceAccounts:
          server:
              name: "amp-iamproxy-ingest-service-account"
              annotations:
                  eks.amazonaws.com/role-arn: "arn:aws:iam::${data.aws_caller_identity.caller.account_id}:role/${var.project_name}-role-prometheus"

      kube-state-metrics:
          tolerations:
            - key: dedicated
              value: addon

      prometheus-pushgateway:
          tolerations:
            - key: dedicated
              value: addon

      server:
          tolerations:
            - key: dedicated
              value: addon 
          persistentVolume:
            enabled: false
          remoteWrite:
              - url: ${module.prometheus.workspace_prometheus_endpoint}api/v1/remote_write
                sigv4:
                  region: ${var.region}
                queue_config:
                  max_samples_per_send: 1000
                  max_shards: 200
                  capacity: 2500

    EOF
  ]
}
