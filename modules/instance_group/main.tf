resource "google_compute_health_check" "wp-hp-check" {
  name                = var.health-check-name
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  tcp_health_check {
    port = var.health-check-port
  }
}

resource "google_compute_region_instance_group_manager" "wp-inst-group" {
  count                            = var.number_of_groups
  base_instance_name               = "${var.base-inst-name}-${count.index}"
  distribution_policy_target_shape = var.distribution_policy_target_shape
  distribution_policy_zones        = var.distrib-zones
  name                             = "${var.inst-group-name}-${count.index}"
  region                           = var.inst-group-region
  target_size                      = var.inst-group-size

  depends_on                       = [google_compute_health_check.wp-hp-check]

  update_policy {
    instance_redistribution_type = lookup(var.update_policy, "instance_redistribution_type", null)
    max_surge_fixed              = lookup(var.update_policy, "max_surge_fixed", null)
    max_unavailable_fixed        = lookup(var.update_policy, "max_unavailable_fixed", null)
    minimal_action               = lookup(var.update_policy, "minimal_action", null)
    replacement_method           = lookup(var.update_policy, "replacement_method", null)
    type                         = lookup(var.update_policy, "type", null)
  }

  named_port {
    name = var.named-port-name
    port = var.named-port-port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.wp-hp-check.name
    initial_delay_sec = var.initial_delay_sec
  }

  version {
    instance_template = var.wp-inst-tp-id
  }

  wait_for_instances_status = var.wait_for_instances_status
}