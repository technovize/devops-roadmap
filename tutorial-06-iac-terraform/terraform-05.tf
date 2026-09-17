data "aws_route53_zone" "main" {
  name = "myapp.com"
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "api.myapp.com"
  type    = "A"
  # ...
}
