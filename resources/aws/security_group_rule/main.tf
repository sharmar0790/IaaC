resource "aws_security_group_rule" "sg_rule" {
  type              = var.sg_rule_type
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  security_group_id = var.destination_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  //  source_security_group_id = var.source_security_group_id == "" ? var.source_security_group_id : null
}
