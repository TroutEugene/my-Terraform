provider "google" {
  project     = var.projID
  region      = "europe-central2"
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "4.0.1"

  project_id   = var.projID
  network_name = "ha-wp-vpc"
  routing_mode = "GLOBAL"

   subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "europe-central2"
            subnet_zone           = "europe-central2-a"
            subnet_flow_logs      = "false"
            description           = "public"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "europe-central2"
            subnet_zone           = "europe-central2-b"
            subnet_private_access = "true"
            subnet_flow_logs      = "false"
            description           = "private"
        }
    ]
        routes = [
        {
            name                   = "internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "internet"
            next_hop_internet      = "true"
            next_hop_gateway       = "global/gateways/default-internet-gateway"
        }
        ]

}



resource "google_service_account" "service_account" {
  account_id   = "wp-service-id"
  display_name = "WordPress service"
  project      = var.projID
}

resource "google_project_iam_member" "service_acc_iam" {
  member  = "serviceAccount:wp-service-id@gcp101388-educoeychernen.iam.gserviceaccount.com"
  project = var.projID
  role    = "roles/storage.objectAdmin"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = module.network.network_id
  address       = "10.10.21.0"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.network.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# MAIN DB INSTANCE =======================================

resource "google_sql_database" "main-database" {
  charset  = "utf8"
  name     = "wordpress"
  instance = google_sql_database_instance.main-instance.name
}

resource "google_sql_database_instance" "main-instance" {
  name             = "db-sql-main"
  region           = "europe-central2"
  database_version = "MYSQL_5_7"
  depends_on = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier = "db-f1-micro"

    activation_policy = "ALWAYS"
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = module.network.network_id
      require_ssl     = "false"
    }

    backup_configuration {
      enabled                        = "true"
      binary_log_enabled             = "true"
      location                       = "eu"
      point_in_time_recovery_enabled = "false"
      start_time                     = "17:00"
    }

    disk_autoresize       = "false"
    disk_autoresize_limit = "0"
    disk_size             = "10"
    disk_type             = "PD_HDD"

  }
  deletion_protection  = "false"
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.main-instance.name
  password = var.db_password
}

# BUCKET =================================================

resource "google_storage_bucket" "static-wordpress" {
  name          = "wp-front"
  location      = "EU"
  force_destroy = true
}

resource "google_storage_bucket_acl" "bucket-acl" {
  bucket = google_storage_bucket.static-wordpress.name

  role_entity = [
    "OWNER:user-wp-service-id@gcp101388-educoeychernen.iam.gserviceaccount.com",
  ]
}

# INSTANCE TEMPLATE ======================================

resource "google_compute_instance_template" "wp-inst-tp" {
  name        = "wp-inst-tp"
  description = "template for wordpress instance."

  metadata = {
    startup-script = file("${path.module}/startup.sh")
  }

  instance_description = "wp instance"
  machine_type         = "e2-micro"
  can_ip_forward       = false

  disk {
    source_image      = "debian-cloud/debian-10"
    auto_delete       = true
    boot              = true
    disk_type         = "pd-ssd"
    disk_size_gb      = "10"
  }

  scheduling {
    automatic_restart   = "false"
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network    = "ha-wp-vpc"
    subnetwork = "subnet-02"
  }

  service_account {
    email  = "wp-service-id@gcp101388-educoeychernen.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

# INSTANCE GROUP ======================================

resource "google_compute_region_instance_group_manager" "wp-inst-group" {
  base_instance_name               = "wordpress-instance"
  distribution_policy_target_shape = "EVEN"
  distribution_policy_zones        = ["europe-central2-a", "europe-central2-b", "europe-central2-c"]
  name                             = "wordpress-instance-group"
  region                           = "europe-central2"
  target_size                      = "2"

  update_policy {
    instance_redistribution_type = "PROACTIVE"
    max_surge_fixed              = "3"
    max_unavailable_fixed        = "3"
    minimal_action               = "REPLACE"
    replacement_method           = "SUBSTITUTE"
    type                         = "OPPORTUNISTIC"
  }

  named_port {
    name = "forward-port"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.wp-hp-check.id
    initial_delay_sec = 300
  }

  version {
    instance_template = google_compute_instance_template.wp-inst-tp.id
  }

  wait_for_instances_status = "STABLE"
}

# HEALTH CHECKS ========================================

resource "google_compute_health_check" "wp-hp-check" {
  name                = "health-check-wp-inst"
  check_interval_sec  = 90
  timeout_sec         = 5
  healthy_threshold   = 1
  unhealthy_threshold = 3

  tcp_health_check {
    port = "22"
  }
}

resource "google_compute_health_check" "lb-wp-hp-check" {
  name                = "health-check-wp-inst-lb"
  check_interval_sec  = 90
  timeout_sec         = 5
  healthy_threshold   = 1
  unhealthy_threshold = 3

  http_health_check {
    port = "80"
  }
}

# LOAD BALANCER ========================================

resource "google_compute_backend_service" "backend-service" {
  affinity_cookie_ttl_sec = "0"

  depends_on = [google_compute_health_check.lb-wp-hp-check]

  backend {
    balancing_mode               = "UTILIZATION"
    capacity_scaler              = "1"
    group                        = "https://www.googleapis.com/compute/v1/projects/gcp101388-educoeychernen/regions/europe-central2/instanceGroups/wordpress-instance-group"
  }

  connection_draining_timeout_sec = "300"
  enable_cdn                      = "false"
  health_checks                   = [google_compute_health_check.lb-wp-hp-check.id]
  load_balancing_scheme           = "EXTERNAL"
  name                            = "wp-lb"
  port_name                       = "forward-port"
  protocol                        = "HTTP"
  session_affinity                = "CLIENT_IP"
  timeout_sec                     = "30"
}

resource "google_compute_target_http_proxy" "lb-target" {
  name            = "lb-forwarding-target"
  url_map         = google_compute_url_map.wp-lb-url-map.id
}

resource "google_compute_global_address" "gb-lb-adress" {
  name = "proxy-target-ip"
}

resource "google_compute_url_map" "wp-lb-url-map" {
  name            = "wp-lb-url-map"
  default_service = google_compute_backend_service.backend-service.id
}

resource "google_compute_global_forwarding_rule" "forward-rule" {
  name                  = "wp-ha-forwarding-rule"
  #backend_service       = google_compute_backend_service.backend-service.id
  ip_protocol           = "TCP"
  #all_ports             = "false"
  #allow_global_access   = "false"
  load_balancing_scheme = "EXTERNAL"
  #network_tier          = "PREMIUM"
  #ports                 = ["443", "80"]
  port_range            = "80"
  target                = google_compute_target_http_proxy.lb-target.id
  ip_address            = google_compute_global_address.gb-lb-adress.id
  #network               = "ha-wp-vpc"
  #subnetwork            = "subnet-01"
}