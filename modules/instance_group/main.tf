resource "google_compute_health_check" "wp-hp-check" {
  name                = "health-check-wp-inst"
  check_interval_sec  = 90
  timeout_sec         = 5
  healthy_threshold   = 1
  unhealthy_threshold = 3

  tcp_health_check {
    port = "22"
  }
}

resource "google_compute_region_instance_group_manager" "wp-inst-group" {
  base_instance_name               = "wordpress-instance"
  distribution_policy_target_shape = "EVEN"
  distribution_policy_zones        = ["europe-central2-a", "europe-central2-b", "europe-central2-c"]
  name                             = "wordpress-instance-group"
  region                           = "europe-central2"
  target_size                      = "2"

  depends_on                       = [google_compute_health_check.wp-hp-check]

  update_policy {
    instance_redistribution_type = "PROACTIVE"
    max_surge_fixed              = "3"
    max_unavailable_fixed        = "3"
    minimal_action               = "REPLACE"
    replacement_method           = "SUBSTITUTE"
    type                         = "OPPORTUNISTIC"
  }

  named_port {
    name = "forward-port"
    port = 80
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