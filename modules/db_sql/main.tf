resource "google_compute_global_address" "private_ip_address" {
  name          = var.private-ip-ad-name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.private-ip-ad-prefix
  network       = var.network_id
  address       = var.private-ip-ad
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "main-instance" {
  name             = var.db-instance-name 
  region           = var.database-region
  database_version = var.database-version
  depends_on = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier = var.database-size

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
      location                       = var.db-backup-location
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
  name     = var.database-name
  instance = google_sql_database_instance.main-instance.name
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.main-instance.name
  password = var.db_password
}