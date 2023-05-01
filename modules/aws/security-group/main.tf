resource "aws_security_group" "main" {
  count       = length(var.security_groups) > 0 ? length(var.security_groups) : 0
  name        = try("${var.security_groups[count.index].name}-SG", null)
  description = try("${var.security_groups[count.index].description}-SG", null)
  vpc_id      = try(var.vpc_id, "")

  dynamic "ingress" {
    //for_each = try([var.security_groups[count.index].ingress], [])
    for_each = { for sg in var.security_groups[count.index].ingress : sg.from_port => sg }
    content {
      from_port        = try(ingress.value.from_port, 0)
      protocol         = try(ingress.value.protocol, "-1")
      to_port          = try(ingress.value.to_port, 0)
      cidr_blocks      = try(ingress.value.cidr_blocks, null)
      description      = try(ingress.value.description, null)
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(ingress.value.prefix_list_ids, null)
      security_groups  = try(ingress.value.security_groups, var.ingress_security_groups)
      self             = try(ingress.value.self, false)
    }
  }

  dynamic "egress" {
    //    for_each = try([var.security_groups[count.index].egress], [])
    for_each = { for sg in var.security_groups[count.index].ingress : sg.from_port => sg }
    content {
      from_port        = try(egress.value.from_port, 0)
      protocol         = try(egress.value.protocol, "-1")
      to_port          = try(egress.value.to_port, 0)
      cidr_blocks      = try(egress.value.cidr_blocks, null)
      description      = try(egress.value.description, null)
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(egress.value.prefix_list_ids, null)
      //security_groups  = try(egress.value.security_groups, null)
      self = try(egress.value.self, false)
    }
  }

  tags = merge({
    Name = "${var.security_groups[count.index].name}-SG"
  }, var.sg_additional_tags, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
    name]
  }
}
