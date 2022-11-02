resource "google_compute_health_check" "lb-wp-hp-check" {
  name                = var.lb-hp-check-name
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    port = var.lb-check-port
  }
}

resource "google_compute_backend_service" "backend-service" {
  affinity_cookie_ttl_sec = var.affinity_cookie_ttl_sec

  depends_on = [google_compute_health_check.lb-wp-hp-check]

  backend {
    balancing_mode               = lookup(var.backend, "balancing_mode", null)
    capacity_scaler              = lookup(var.backend, "capacity_scaler", null)
    group                        = lookup(var.backend, "group", null)
  }

  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  enable_cdn                      = var.enable_cdn
  health_checks                   = [google_compute_health_check.lb-wp-hp-check.id]
  load_balancing_scheme           = var.load_balancing_scheme
  name                            = var.backend-serv-name
  port_name                       = var.backend-port-name
  protocol                        = var.protocol
  session_affinity                = var.session_affinity
  timeout_sec                     = var.timeout_sec
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
  ip_protocol           = var.ip_protocol
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.fw-rule-ports
  target                = google_compute_target_http_proxy.lb-target.id
  ip_address            = google_compute_global_address.gb-lb-adress.id
}