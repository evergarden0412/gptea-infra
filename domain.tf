resource "aws_route53_record" "gptea_ns" {
  zone_id = "Z03023572FM82BE5HO2P4"
  name    = "gptea.keenranger.dev"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.gptea.name_servers
}

resource "aws_route53_record" "gptea_test_ns" {
  zone_id = "Z03023572FM82BE5HO2P4"
  name    = "gptea-test.keenranger.dev"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.gptea_test.name_servers
}

resource "aws_route53_zone" "gptea" {
  name    = "gptea.keenranger.dev"
  comment = "Zone for gptea.keenranger.dev"
  tags = {
    Name = "gptea.keenranger.dev"
  }
}

resource "aws_route53_zone" "gptea_test" {
  name    = "gptea-test.keenranger.dev"
  comment = "Zone for gptea-test.keenranger.dev"
  tags = {
    Name = "gptea-test.keenranger.dev"
  }
}

resource "aws_acm_certificate" "gptea" {
  domain_name       = "*.gptea.keenranger.dev"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "gptea_test" {
  domain_name       = "*.gptea-test.keenranger.dev"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "gptea_us_east_1" {
  domain_name       = "gptea.keenranger.dev"
  validation_method = "DNS"
  provider          = aws.us-east-1
}
  
resource "aws_acm_certificate" "gptea_test_us_east_1" {
  domain_name       = "gptea-test.keenranger.dev"
  validation_method = "DNS"
  provider          = aws.us-east-1
}

resource "aws_route53_record" "gptea_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.gptea.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.gptea.id
}

resource "aws_route53_record" "gptea_test_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.gptea_test.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.gptea_test.id
}

resource "aws_route53_record" "gptea_us_east_1_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.gptea_us_east_1.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.gptea.id 
}

resource "aws_route53_record" "gptea_test_us_east_1_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.gptea_test_us_east_1.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.gptea_test.id
}

resource "aws_acm_certificate_validation" "gptea" {
  certificate_arn         = aws_acm_certificate.gptea.arn
  validation_record_fqdns = [for record in aws_route53_record.gptea_cert_validation : record.fqdn]
}

resource "aws_acm_certificate_validation" "gptea_test" {
  certificate_arn         = aws_acm_certificate.gptea_test.arn
  validation_record_fqdns = [for record in aws_route53_record.gptea_test_cert_validation : record.fqdn]
}

resource "aws_acm_certificate_validation" "gptea_us_east_1" {
  certificate_arn         = aws_acm_certificate.gptea_us_east_1.arn
  validation_record_fqdns = [for record in aws_route53_record.gptea_us_east_1_cert_validation : record.fqdn]
  provider                = aws.us-east-1
}

resource "aws_acm_certificate_validation" "gptea_test_us_east_1" {
  certificate_arn         = aws_acm_certificate.gptea_test_us_east_1.arn
  validation_record_fqdns = [for record in aws_route53_record.gptea_test_us_east_1_cert_validation : record.fqdn]
  provider                = aws.us-east-1
}