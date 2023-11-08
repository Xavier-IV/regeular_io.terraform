resource "aws_wafv2_web_acl" "waf_lb" {
  name  = "${var.global_app.name.pascal}RuleWAF"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-crs
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.global_app.name.kebab}-common-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2

    override_action {
      count {}
    }

    statement {
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-sql-db
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.global_app.name.kebab}-sqli-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 3

    override_action {
      count {}
    }

    statement {
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-linux-os
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.global_app.name.kebab}-linux-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 4

    override_action {
      count {}
    }

    statement {
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-known-bad-inputs
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.global_app.name.kebab}-linux-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 5

    override_action {
      count {}
    }

    statement {
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-ip-rep.html#aws-managed-rule-groups-ip-rep-amazon
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.global_app.name.kebab}-ip-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 6

    override_action {
      count {}
    }

    statement {
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-ip-rep.html#aws-managed-rule-groups-ip-rep-anonymous
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.global_app.name.kebab}-anonymous-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Environment = var.global_app.tag.environment
    Application = var.global_app.tag.name
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.global_app.name.kebab}-rule-metric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association_my_lb" {
  resource_arn = var.module-load-balancer.lb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_lb.arn
}

resource "aws_cloudwatch_log_group" "cloudwatch_logs" {
  name = "aws-waf-logs-${var.global_app.name.kebab}"

  tags = {
    Environment = "production"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "log_config" {
  log_destination_configs = [aws_cloudwatch_log_group.cloudwatch_logs.arn]
  resource_arn            = aws_wafv2_web_acl.waf_lb.arn
}