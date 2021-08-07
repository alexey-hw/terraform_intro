output "vpc" {
  value = module.vpc
}

output "sg_id" {
  value = {
    db      = aws_security_group.db_sg.id
    app     = aws_security_group.app_sg.id
    bastion = aws_security_group.bastion_sg.id
    lb      = aws_security_group.lb_sg.id
  }
}
