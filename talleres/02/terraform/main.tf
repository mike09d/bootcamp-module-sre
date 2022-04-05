
# ## SECURITY GROUP

module "sgs" {
  source = "./modules/security-group"
  project_name = var.project_name
  vpc_id = data.aws_vpc.default.id
  cidr_block = data.aws_vpc.default.cidr_block
  ports = [8000, 80]
}
# ## AUTOSCALING GROUP

# module "asg" {
#   source = "./modules/asg"
#   project_name = var.project_name
#   sg_id = module.sgs.ids[0]
#   subnet_ids_private = data.aws_subnet_ids.private.ids
#   lb_target_arn = module.alb.lb_target_main_arn
# }


# ## LOAD BALANCER

# module "alb" {
#   source = "./modules/loadbalancer"
#   project_name = var.project_name
#   sg_id = module.sgs.ids[1]
#   subnet_ids_private = data.aws_subnet_ids.private.ids
#   vpc_id = data.aws_vpc.default.id
#   ag_backend_id = module.asg.ag_backend_id
# }


module "ecr"{
  source = "./modules/ecr"
  name = "mf"
}