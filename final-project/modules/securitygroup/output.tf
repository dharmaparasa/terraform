output "sg_id" {
    description = "The Id of the SG created"
    value = aws_security_group.name.id
}