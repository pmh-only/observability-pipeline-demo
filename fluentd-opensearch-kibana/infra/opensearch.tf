module "opensearch" {
  source = "terraform-aws-modules/opensearch/aws"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  advanced_security_options = {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true

    master_user_options = {
      master_user_name     = "example"
      master_user_password = "Barbarbarbar1!"
    }
  }

  auto_tune_options = {
    desired_state = "ENABLED"

    maintenance_schedule = [
      {
        start_at                       = "2028-05-13T07:44:12Z"
        cron_expression_for_recurrence = "cron(0 0 ? * 1 *)"
        duration = {
          value = "2"
          unit  = "HOURS"
        }
      }
    ]

    rollback_on_disable = "NO_ROLLBACK"
  }

  cluster_config = {
    instance_count           = 3
    dedicated_master_enabled = true
    dedicated_master_type    = "c6g.large.search"
    instance_type            = "r6g.large.search"

    zone_awareness_config = {
      availability_zone_count = 3
    }

    zone_awareness_enabled = true
  }

  domain_endpoint_options = {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  domain_name = "${var.project_name}-opensearch"

  ebs_options = {
    ebs_enabled = true
    iops        = 3000
    throughput  = 125
    volume_type = "gp3"
    volume_size = 20
  }

  encrypt_at_rest = {
    enabled = true
  }

  engine_version = "OpenSearch_2.13"

  log_publishing_options = [
    { log_type = "INDEX_SLOW_LOGS" },
    { log_type = "SEARCH_SLOW_LOGS" },
  ]

  node_to_node_encryption = {
    enabled = true
  }

  software_update_options = {
    auto_software_update_enabled = true
  }

  vpc_options = {
    subnet_ids = [
      "subnet-03c95bf31de68568a",
      "subnet-0123fb8e27e80446d",
      "subnet-09e9032306e6fa1f6"
    ]
  }

  # VPC endpoint
  vpc_endpoints = {
    one = {
      subnet_ids = [
        "subnet-03c95bf31de68568a",
        "subnet-0123fb8e27e80446d",
        "subnet-09e9032306e6fa1f6"
      ]
    }
  }

  
  security_group_rules = {
    ingress_443 = {
      type        = "ingress"
      description = "HTTPS access from VPC"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # Access policy
  access_policy_statements = [
    {
      effect = "Allow"

      principals = [{
        type        = "*"
        identifiers = ["*"]
      }]

      actions = ["es:*"]

      condition = [{
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = ["${chomp(data.http.myip.response_body)}/32"]
      }]
    }
  ]
}
