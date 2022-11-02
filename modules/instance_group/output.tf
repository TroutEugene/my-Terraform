output "wp-inst-group-id" {
  value = [
    for id in google_compute_region_instance_group_manager.wp-inst-group : id
  ]
}