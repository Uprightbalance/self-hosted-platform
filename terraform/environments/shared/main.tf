module "vpc" {
  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "networking" {
  source              = "../../modules/networking"
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "security_groups" {
  source = "../../modules/security-groups"
  vpc_id = module.vpc.vpc_id
  my_ip  = var.my_ip
}

module "compute" {
  source            = "../../modules/compute"
  public_subnet_id  = module.networking.public_subnet_id
  private_subnet_id = module.networking.private_subnet_id
  bastion_sg_id     = module.security_groups.bastion_sg_id
  k8s_sg_id         = module.security_groups.k8s_sg_id
  public_key        = var.public_key
}
