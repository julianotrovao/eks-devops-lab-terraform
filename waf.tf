resource "aws_wafv2_web_acl" "main" {
  name        = "waf-devops-lab"
  description = "Proteção para o Gateway API do EKS"
  scope       = "REGIONAL" # 'REGIONAL' para ALB, 'CLOUDFRONT' para CloudFront

  default_action {
    allow {}
  }

  # Regra 1: Core Rule Set (Proteção contra OWASP Top 10)
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFCommonRules"
      sampled_requests_enabled   = true
    }
  }

  # Regra 2: Amazon IP Reputation List (Bloqueia IPs de bots e hackers conhecidos)
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFIPReputation"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "MainWAF"
    sampled_requests_enabled   = true
  }
}