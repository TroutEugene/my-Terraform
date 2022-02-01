resource "google_compute_health_check" "lb-wp-hp-check" {
  name                = var.lb-hp-check-name
  check_interval_sec  = 90
  timeout_sec         = 5
  healthy_threshold   = 1
  unhealthy_threshold = 3

  http_health_check {
    port = var.lb-check-port
  }
}

resource "google_compute_backend_service" "backend-service" {
  affinity_cookie_ttl_sec = "0"

  depends_on = [google_compute_health_check.lb-wp-hp-check]

  backend {
    balancing_mode               = "UTILIZATION"
    capacity_scaler              = "1"
    group                        = var.group-name
  }

  connection_draining_timeout_sec = "300"
  enable_cdn                      = "false"
  health_checks                   = [google_compute_health_check.lb-wp-hp-check.id]
  load_balancing_scheme           = "EXTERNAL"
  name                            = var.backend-serv-name
  port_name                       = var.backend-port-name
  protocol                        = "HTTP"
  session_affinity                = "CLIENT_IP"
  timeout_sec                     = "30"
}

resource "google_compute_target_http_proxy" "lb-target" {
  name            = var.http-proxy-name
  url_map         = google_compute_url_map.wp-lb-url-map.id
}

resource "google_compute_global_address" "gb-lb-adress" {
  name = var.lb-global-ip-name
}

resource "google_compute_url_map" "wp-lb-url-map" {
  name            = var.url-map-name
  default_service = google_compute_backend_service.backend-service.id
}

resource "google_compute_global_forwarding_rule" "forward-rule" {
  name                  = var.fw-rule-name
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = var.fw-rule-ports
  target                = google_compute_target_http_proxy.lb-target.id
  ip_address            = google_compute_global_address.gb-lb-adress.id
}