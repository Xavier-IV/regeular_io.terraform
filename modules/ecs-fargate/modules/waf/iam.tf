## More info can be found here:
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_waf_policy" {
  policy_document = data.aws_iam_policy_document.cloudwatch_waf.json
  policy_name     = "cloudwatch-waf-policy"
}

data "aws_iam_policy_document" "cloudwatch_waf" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.cloudwatch_logs.arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}