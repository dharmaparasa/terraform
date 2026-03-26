


resource "aws_security_group" "name" {
    name = "DharmaSG"

    dynamic "ingress" {
      for_each = [
        for port in [22,80]:{
            from_port=port
            to_port=port
            protocol="tcp"
            cidr_blocks=["0.0.0.0/0"]
        }
      ]
      content {
        from_port = ingress.value.from_port
        to_port = ingress.value.to_port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
    }

    egress {
        from_port = 0
        to_port= 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}