resource "google_compute_network" "vpc_network" {
  name = "ha-wp-vpc"
}

resource "google_compute_subnetwork" "public_subnet" {
  name = "subnet-01-publilc"
  ip_cidr_range = "10.0.10.0/24"
  region = "europe-central2"
  network = google_compute_network.vpc_network.name
  #depends_on    = [google_compute_network.vpc_network]
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "subnet-02-publilc"
  ip_cidr_range = "10.0.20.0/24"
  network       = google_compute_network.vpc_network.name
  region        = "europe-central2"
  private_ip_google_access = "true"
  #depends_on    = [google_compute_network.vpc_network]
}

resource "google_compute_router" "gw-for-inst-group" {
  encrypted_interconnect_router = "false"
  name                          = "router-wp-insts"
  network                       = google_compute_network.vpc_network.name
  region                        = "europe-central2"
}

resource "google_compute_router_nat" "nat-for-wp" {
  name                               = "nat-for-wp-insts"
  router                             = google_compute_router.gw-for-inst-group.name
  region                             = google_compute_router.gw-for-inst-group.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}