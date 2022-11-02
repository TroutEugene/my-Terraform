resource "google_compute_instance_template" "wp-inst-tp" {
  name        = var.template-name
  description = var.template-desc

  metadata = {
    startup-script = var.startup-script
  }

  instance_description = var.instance_description
  machine_type         = var.machine-size
  can_ip_forward       = var.can_ip_forward

  disk {
    source_image      = lookup(var.disk, "source_image", null)
    auto_delete       = lookup(var.disk, "auto_delete", null)
    boot              = lookup(var.disk, "boot", null)
    disk_type         = lookup(var.disk, "disk_type", null)
    disk_size_gb      = lookup(var.disk, "disk_size_gb", null)
  }

  scheduling {
    automatic_restart   = var.automatic_restart
    on_host_maintenance = var.on_host_maintenance
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }

  service_account {
    email  = var.service-acc
    scopes = var.service_account_scope
  }
}