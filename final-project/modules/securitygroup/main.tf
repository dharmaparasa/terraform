resource "aws_security_group" "name" {
    name = var.sg-name
    vpc_id = var.sg-vpc
    dynamic "ingress" {
        for_each = [
            for port,cidr in var.ingress-rule-map:{
                from_port=port
                to_port=port
                cidr_blocks=[cidr]
                protocol="tcp"
            }
        ]
      content {
          from_port   = ingress.value.from_port
          to_port     = ingress.value.to_port
          protocol    = ingress.value.protocol
          cidr_blocks = ingress.value.cidr_blocks
      }
    }

    egress {
        from_port = 0
        to_port= 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name=var.name-tag
    }
}
