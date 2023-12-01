resource "aws_vpc" "primary" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "primary" {
  vpc_id     = aws_vpc.primary.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "primary" {
  description = "Primary security group for teamspeak"
  vpc_id      = aws_vpc.primary.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp" {
  for_each = {
    "Filetransfer"   = 30033
    "ServerQueryRaw" = 10011
    "ServerQuerySSH" = 10022
    "WebQueryHTTP"   = 10080
    "WebQueryHTTPS"  = 10443
    "TSDNS"          = 41144
  }
  security_group_id            = aws_security_group.primary.id
  referenced_security_group_id = aws_security_group.primary.id
  ip_protocol                  = "tcp"
  description                  = each.key
  from_port                    = each.value
  to_port                      = each.value
}

resource "aws_vpc_security_group_ingress_rule" "allow_udp" {
  for_each = {
    "Voice" = 9987
  }
  security_group_id            = aws_security_group.primary.id
  referenced_security_group_id = aws_security_group.primary.id
  ip_protocol                  = "udp"
  description                  = each.key
  from_port                    = each.value
  to_port                      = each.value
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id            = aws_security_group.primary.id
  referenced_security_group_id = aws_security_group.primary.id
  description                  = "Allow all egress"
  ip_protocol                  = -1
}