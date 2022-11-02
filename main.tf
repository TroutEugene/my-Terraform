provider "google" {
  project     = var.projID
  region      = var.region
}
module "network" {
  source           = "./modules/network"
  network-name     = "ha-wp-vpc"
  pub-subnet-name  = "subnet-01-publilc"
  ip-range-pub     = "10.0.10.0/24"
  priv-subnet-name = "subnet-02-publilc"
  ip-range-priv    = "10.0.20.0/24"
  network-region   = var.region
  router-name      = "router-wp-insts"
  router-nat-name  = "nat-for-wp-insts"
}
module "service_account" {
  source        = "./modules/service_account"
  serv-acc-id   = "wp-service-id"
  serv-acc-name = "WordPress service" 
  serv-acc-role = "roles/storage.objectAdmin"
  projID        = var.projID
}
module "db_sql" {
  source                = "./modules/db_sql"
  network_id            = module.network.network_id
  private-ip-ad-name    = "private-ip-address"
  private-ip-ad         = "10.10.21.0"
  private-ip-ad-prefix  = "24"
  db-instance-name      = "db-sql-main"
  database-region       = "europe-central2"
  database-version      = "MYSQL_5_7"
  db_username           = var.db_username
  db_password           = var.db_password
  database-size         = "db-f1-micro"
  db-backup-location    = "eu"
  database-name         = "wordpress"
}
module "bucket" {
  source            = "./modules/bucket"
  bucket-name       = "wp-front"
  location          = "EU"
  service-acc       = module.service_account.email
}
module "instance_template" {
  source          = "./modules/instance_template"
  template-name   = "wp-inst-tp"
  template-desc   = "template for wordpress instance."
  service-acc     = module.service_account.email
  network         = module.network.network_id
  subnetwork      = module.network.subnetwork_id
  startup-script  = file("./modules/instance_template/startup.sh")
  machine-size    = "e2-micro"
  disk-size       = "10"
}
module "instance_group" {
  source            = "./modules/instance_group"
  wp-inst-tp-id     = module.instance_template.wp-inst-id
  health-check-name = "health-check-wp-inst"
  health-check-port = "22"
  base-inst-name    = "wordpress-instance"
  inst-group-name   = "wordpress-instance-group"
  distrib-zones     = ["europe-central2-a", "europe-central2-b", "europe-central2-c"]
  inst-group-region = var.region
  inst-group-size   = "2"
  size-overload     = "3"
  named-port-name   = "forward-port"
  named-port-port   = 80
  depends_on        = [module.instance_template]
}
module "load_balancer" {
  source            = "./modules/load_balancer"
  lb-hp-check-name  = "health-check-wp-inst-lb"
  lb-check-port     = "80"
  backend-serv-name = "wp-lb"
  backend-port-name = "forward-port"
  group-name        = module.instance_group.wp-inst-group-id
  http-proxy-name   = "lb-forwarding-target"
  lb-global-ip-name = "proxy-target-ip"
  url-map-name      = "wp-lb-url-map"
  fw-rule-name      = "wp-ha-forwarding-rule"
  fw-rule-ports     = "80"
  depends_on        = [module.instance_template]
  network           = module.network.network_id
}