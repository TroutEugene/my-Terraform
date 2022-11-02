resource "google_compute_global_address" "private_ip_address" {
  name          = var.private-ip-ad-name
  purpose       = var.purpose
  address_type  = var.address_type
  prefix_length = var.private-ip-ad-prefix
  network       = var.network_id
  address       = var.private-ip-ad
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = var.service_networking
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "main-instance" {
  name             = var.db-instance-name 
  region           = var.database-region
  database_version = var.database-version
  depends_on = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier = var.database-size

    activation_policy = var.sql_activation_policy
    availability_type = var.sql_availability_type

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.network_id
      require_ssl     = var.require_ssl
    }

    backup_configuration {
      enabled                        = lookup(var.backup_config, "enabled", null)
      binary_log_enabled             = lookup(var.backup_config, "binary_log_enabled", null)
      location                       = lookup(var.backup_config, "location", null)
      point_in_time_recovery_enabled = lookup(var.backup_config, "point_in_time_recovery_enabled", null)
      start_time                     = lookup(var.backup_config, "start_time", null)
    }

    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    disk_size             = var.disk_size
    disk_type             = var.disk_type

  }
  deletion_protection  = var.deletion_protection
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