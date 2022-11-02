provider "google" {
  project     = var.projID
  region      = var.region
}

module "registries" {
  source = "./module"
  format_id = {
    py-package = "Python"
    apt-package = "Apt"
  }
  location = var.region
}