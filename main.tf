module "network" {
  source     = "./modules/network"
  namespace  = var.namespace
  my_ip_cidr = var.my_ip_cidr
}

module "application" {
  source      = "./modules/application"
  namespace   = var.namespace
  sg_id       = module.network.sg_id
  vpc         = module.network.vpc
  ssh_keypair = var.ssh_keypair
  db_config   = module.database.db_config
}

module "database" {
  source    = "./modules/database"
  namespace = var.namespace
  sg_id     = module.network.sg_id
  vpc       = module.network.vpc
}
