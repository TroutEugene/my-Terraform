resource "google_compute_health_check" "wp-hp-check" {
  name                = var.health-check-name
  check_interval_sec  = 90
  timeout_sec         = 5
  healthy_threshold   = 1
  unhealthy_threshold = 3

  tcp_health_check {
    port = var.health-check-port
  }
}

resource "google_compute_region_instance_group_manager" "wp-inst-group" {
  base_instance_name               = var.base-inst-name
  distribution_policy_target_shape = "EVEN"
  distribution_policy_zones        = var.distrib-zones
  name                             = var.inst-group-name
  region                           = var.inst-group-region
  target_size                      = var.inst-group-size

  depends_on                       = [google_compute_health_check.wp-hp-check]

  update_policy {
    instance_redistribution_type = "PROACTIVE"
    max_surge_fixed              = var.size-overload
    max_unavailable_fixed        = "3"
    minimal_action               = "REPLACE"
    replacement_method           = "SUBSTITUTE"
    type                         = "OPPORTUNISTIC"
  }

  named_port {
    name = var.named-port-name
    port = var.named-port-port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.wp-hp-check.name
    initial_delay_sec = 300
  }

  version {
    instance_template = var.wp-inst-tp-id
  }

  wait_for_instances_status = "STABLE"
}