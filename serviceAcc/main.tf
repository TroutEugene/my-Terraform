provider "google" {
  project     = var.projID
  region      = var.region
}

module "service_account" {
  source        = "./service_account"
  projID        = var.projID
  servAcc = [ {
    serv-acc-id   = "wp-service-id"
    serv-acc-name = "WordPress service" 
  }
   ]
  accRoles =     {
    wp-service-id = "roles/cloudkms.cryptoKeyDecrypter"
    wp-service-id = "roles/storage.objectAdmin"
    wp-service-id = "roles/cloudkms.cryptoKeyEncrypter"
  }
}

