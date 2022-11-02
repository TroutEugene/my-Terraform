projID = "gcp101388-educoeychernen"
region = "europe-central2"
network_name = "wordpress-prod"

subnets = [ {
    subnet_name           = "private-subnet"
    subnet_ip             = "10.0.20.0/24"
    subnet_region         = "europe-central2"
    subnet_private_access = "true"
    subnet_flow_logs      = "false"
    description           = "This is a subnet without an internet access"
},
{
    subnet_name           = "public-subnet"
    subnet_ip             = "10.0.10.0/24"
    subnet_region         = "europe-central2"
    subnet_private_access = "true"
    subnet_flow_logs      = "false"
    description           = "This is a subnet for public connections"
}
]

rules = [ {
    name                    = "ssh-through-IAP"
    description             = "ssh-for-me-IAP"
    direction               = "INGRESS"
    priority                = 333
    ranges                  = ["35.235.240.0/20"]
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
},{
    name                    = "wordpress-http"
    direction               = "INGRESS"
    priority                = 400
    ranges                  = ["0.0.0.0/0"]
    allow = [{
      protocol = "tcp"
      ports    = ["80"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
}
 ]

router_name = "wp-nat-router"
subnet_name = "public-subnet"

nat = [ {
    name = "nat-for-wp"
} ]

iam_mode = "authoritative"

bindings = {
  "roles/storage.objectAdmin" = [
    "serviceAccount:wp-service-id@gcp101388-educoeychernen.iam.gserviceaccount.com"
  ]
}

wp_service_account = "wp-service-account"

backup_config = {
  enabled                        = "true"
  binary_log_enabled             = "true"
  location                       = "eu"
  point_in_time_recovery_enabled = "false"
  start_time                     = "17:00"
}

secret_db_username = "db_user_name"
secret_db_password = "db_password"

private-ip-ad-name    = "private-ip-address"
private-ip-ad         = "10.10.21.0"
private-ip-ad-prefix  = "24"
db-instance-name      = "db-sql-main"
database-region       = "europe-central2"
database-version      = "MYSQL_5_7"
database-size         = "db-f1-micro"
database-name         = "wordpress"

instance_template_disk = {
    source_image      = "debian-cloud/debian-10"
    auto_delete       = true
    boot              = true
    disk_type         = "pd-ssd"
    disk_size_gb      = "10"
}
update_policy = {
    instance_redistribution_type = "PROACTIVE"
    max_surge_fixed              = "3"
    max_unavailable_fixed        = "3"
    minimal_action               = "REPLACE"
    replacement_method           = "SUBSTITUTE"
    type                         = "OPPORTUNISTIC"
}
template-name   = "wp-inst-tp"
template-desc   = "template for wordpress instance."
#startup-script  = file("./modules/instance_template/startup.sh")
machine-size    = "e2-micro"

health-check-name = "health-check-wp-inst"
health-check-port = "22"
base-inst-name    = "wordpress-instance"
inst-group-name   = "wordpress-instance-group"
distrib-zones     = ["europe-central2-a", "europe-central2-b", "europe-central2-c"]
inst-group-size   = "2"
named-port-name   = "forward-port"
named-port-port   = 80

lb-hp-check-name  = "health-check-wp-inst-lb"
lb-check-port     = "80"
backend-serv-name = "wp-lb"
backend-port-name = "forward-port"

http-proxy-name   = "lb-forwarding-target"
lb-global-ip-name = "proxy-target-ip"
url-map-name      = "wp-lb-url-map"
fw-rule-name      = "wp-ha-forwarding-rule"
fw-rule-ports     = "80"