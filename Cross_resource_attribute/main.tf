provider "aws" {
  region  = "eu-central-1"
  profile = "personal"
}

resource "aws_eip" "lb" {
    domain = "vpc"
}
//Output values
output "public-ip" {
    value = aws_eip.lb.public_ip
}

/*resource "aws_security_group" "allow_tls" {
  name        = "attribute-firewall"
  description = "Managed from terraform test"

}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "${aws_eip.lb.public_ip}/32"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
*/