data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-config.yaml", var.db_config)
  }
}

resource "aws_instance" "bastion_host" {
  count                  = length(var.vpc.public_subnets)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.sg_id.bastion]
  subnet_id              = var.vpc.public_subnets[count.index]
  key_name               = var.ssh_keypair

  tags = {
    Name = "bastion_host-${var.namespace}"
  }
}

resource "aws_launch_template" "application_lt" {
  name_prefix   = var.namespace
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  user_data     = data.cloudinit_config.config.rendered
  key_name      = var.ssh_keypair

  tags = {
    Name = "application_lt-${var.namespace}"
  }
}

resource "aws_instance" "application_host" {
  count                  = length(var.vpc.public_subnets)
  subnet_id              = var.vpc.private_subnets[count.index]
  vpc_security_group_ids = [var.sg_id.app]

  launch_template {
    id      = aws_launch_template.application_lt.id
    version = aws_launch_template.application_lt.latest_version
  }

  tags = {
    Name = "application_host-${var.namespace}"
  }
}

module "alb" {
  source                           = "terraform-aws-modules/alb/aws"
  version                          = "~> 5.0"
  name                             = var.namespace
  load_balancer_type               = "application"
  vpc_id                           = var.vpc.vpc_id
  subnets                          = var.vpc.public_subnets
  security_groups                  = [var.sg_id.lb]
  enable_cross_zone_load_balancing = true

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "app"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      targets = [
        for inst in aws_instance.application_host :
        {
          target_id = inst.id
        }
      ]
    }
  ]
}
