provider "google" {
  project     = var.projID
  region      = var.region
}
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 4.0.0"
    project_id   = var.projID
    network_name = var.network_name
    shared_vpc_host = false

    subnets = var.subnets
}
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 3.0.0"
  project     = var.projID
  region      = var.region

  name    = var.router_name
  network = var.network_name
  nats    = var.nat
}

resource "google_service_account" "wp_service_account" {
  account_id   = var.wp_service_account
  display_name = var.wp_service_account
  project      = var.projID
}

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 6.4"
  mode    = var.iam_mode
  bindings = var.bindings
}

module "db_sql" {
  source                = "./modules/db_sql"
  network_id            = module.vpc.network_id
  private-ip-ad-name    = var.private-ip-ad-name
  private-ip-ad         = var.private-ip-ad
  private-ip-ad-prefix  = var.private-ip-ad-prefix
  db-instance-name      = var.db-instance-name
  database-region       = var.database-region
  database-version      = var.database-version
  backup_config         = var.backup_config
  db_username           = data.google_secret_manager_secret_version.db_username.secret
  db_password           = data.google_secret_manager_secret_version.db_password.secret
  database-size         = var.database-size
  database-name         = var.database-name
}

data "google_secret_manager_secret_version" "db_username" {
  secret = var.secret_db_username
}

data "google_secret_manager_secret_version" "db_password" {
  secret = var.secret_db_password
}
module "instance_template" {
  source          = "./modules/instance_template"
  template-name   = var.template-name
  template-desc   = var.template-desc
  service-acc     = google_service_account.wp_service_account.email
  network         = module.vpc.network_id
  subnetwork      = var.subnet_name
  startup-script  = var.startup-script
  machine-size    = var.machine-size
  disk            = var.instance_template_disk
}
module "instance_group" {
  source            = "./modules/instance_group"
  wp-inst-tp-id     = module.instance_template.wp-inst-id
  health-check-name = var.health-check-name
  health-check-port = var.health-check-port
  base-inst-name    = var.base-inst-name
  inst-group-name   = var.inst-group-name
  distrib-zones     = var.distrib-zones
  inst-group-region = var.region
  inst-group-size   = var.inst-group-size
  update_policy     = var.update_policy
  named-port-name   = var.named-port-name
  named-port-port   = var.named-port-port
}
module "load_balancer" {
  source            = "./modules/load_balancer"
  lb-hp-check-name  = var.lb-hp-check-name
  lb-check-port     = var.lb-check-port
  backend-serv-name = var.backend-serv-name
  backend-port-name = var.backend-port-name
  backend           = {
    balancing_mode               = "UTILIZATION"
    capacity_scaler              = "1"
    group                        = module.instance_group.wp-inst-group-id}
  http-proxy-name   = var.http-proxy-name
  lb-global-ip-name = var.lb-global-ip-name
  url-map-name      = var.url-map-name
  fw-rule-name      = var.fw-rule-name
  fw-rule-ports     = var.fw-rule-ports
  depends_on        = [module.instance_template]
  network           = module.vpc.network_id
}