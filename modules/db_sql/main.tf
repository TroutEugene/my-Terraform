resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.network_id
  address       = "10.10.21.0"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
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
      private_network = var.network_id
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

resource "google_sql_database" "main-database" {
  charset  = "utf8"
  name     = "wordpress"
  instance = google_sql_database_instance.main-instance.name
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.main-instance.name
  password = var.db_password
}