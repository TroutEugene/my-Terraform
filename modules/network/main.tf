resource "google_compute_network" "vpc_network" {
  name = var.network-name
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = var.pub-subnet-name
  ip_cidr_range = var.ip-range-pub
  region        = var.network-region
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = var.priv-subnet-name
  ip_cidr_range = var.ip-range-priv
  network       = google_compute_network.vpc_network.name
  region        = var.network-region
  private_ip_google_access = "true"
}

resource "google_compute_router" "gw-for-inst-group" {
  encrypted_interconnect_router = "false"
  name                          = var.router-name
  network                       = google_compute_network.vpc_network.name
  region                        = var.network-region
}

resource "google_compute_router_nat" "nat-for-wp" {
  name                               = var.router-nat-name
  router                             = google_compute_router.gw-for-inst-group.name
  region                             = google_compute_router.gw-for-inst-group.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}