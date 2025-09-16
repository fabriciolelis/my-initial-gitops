
locals {
  prefix_name  = "${var.application}-${var.environment}"
  bastion_name = "${local.prefix_name}-bastion"
}

resource "aws_instance" "bastion_host" {
  ami                    = var.bastion_ami
  instance_type          = "t2.micro"
  key_name               = var.bastion_key
  subnet_id              = var.subnets.1
  vpc_security_group_ids = var.security_groups

  tags = merge(
    tomap({ "Service" = "EC2" }),
    tomap({ "Name" = local.bastion_name })
  )

}
