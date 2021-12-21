provider "google" {
  project     = var.projID
  region      = "europe-central2"
}
module "network" {
  source = "./modules/network"
}
module "service_account" {
  source = "./modules/service_account"
  projID      = var.projID
}
module "db_sql" {
  source     = "./modules/db_sql"
  network_id = module.network.network_id
  db_username = var.db_username
  db_password = var.db_password
}
module "bucket" {
  source            = "./modules/bucket"
  service-acc       = module.service_account.email
}
module "instance_template" {
  source      = "./modules/instance_template"
  service-acc = module.service_account.email
  network     = module.network.network_id
  subnetwork  = module.network.subnetwork_id
}
module "instance_group" {
  source          = "./modules/instance_group"
  wp-inst-tp-id   = module.instance_template.wp-inst-id
  depends_on      = [module.instance_template]
}
module "load_balancer" {
  source          = "./modules/load_balancer"
  group-name      = module.instance_group.wp-inst-group-id
  depends_on      = [module.instance_template]
  network         = module.network.network_id
}