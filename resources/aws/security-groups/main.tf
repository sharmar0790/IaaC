resource "aws_security_group" "main" {
  name = "${var.env_name} eks cluster"
  description = "Allow traffic"
  vpc_id = var.vpc_id

  ingress {
    description = var.ingress_description
    from_port = var.ingress_from_port
    to_port = var.ingress_to_port
    protocol = var.ingress_protocol
    #"-1"
    cidr_blocks = var.ingress_cidr_blocks
    #["0.0.0.0/0"]
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_blocks
    #["::/0"]
  }

  egress {
    from_port = var.egress_from_port
    to_port = var.egress_to_port
    protocol = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
    #["0.0.0.0/0"]
    ipv6_cidr_blocks = var.egress_ipv6_cidr_blocks
    #["::/0"]
  }

  tags = merge({
    Name = "EKS ${var.env_name}",
    "kubernetes.io/cluster/${var.eks_cluster_name}" : "owned"
  }, var.tags)
}