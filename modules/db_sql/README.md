# Module instance group

This module is used to create instance groups

## Usage

```hcl
module "instance_group" {
  source            = "./modules/instance_group"
  wp-inst-tp-id     = "inst-id"
  health-check-name = "health-check-wp-inst"
  health-check-port = "22"
  base-inst-name    = "wordpress-instance"
  inst-group-name   = "wordpress-instance-group"
  distrib-zones     = ["europe-central2-a", "europe-central2-b", "europe-central2-c"]
  inst-group-size   = "2"
  update_policy = {
    instance_redistribution_type = "PROACTIVE"
    max_surge_fixed              = "3"
    max_unavailable_fixed        = "3"
    minimal_action               = "REPLACE"
    replacement_method           = "SUBSTITUTE"
    type                         = "OPPORTUNISTIC"
  }
  named-port-name   = "forward-port"
  named-port-port   = 80
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| wp-inst-tp-id | instance template id | `string` | n/a | yes |
| update policy | The update policy for this managed instance group | <pre>object({<br>    instance_redistribution_type        = string<br>    max_surge_fixed       = string<br>    max_unavailable_fixed = string<br>    minimal_action  = string<br>    replacement_method     = string<br>    type     = string<br>  })</pre> | `[]` | no |
| health-check-name | name of healthcheck | `string` | n/a | yes |
| health-check-port | port of healthcheck | `string` | n/a | yes |
| base-inst-name | The base instance name to use for instances in this group | `string` | n/a | yes |
| inst-group-name | name of instance group manager | `string` | n/a | yes |
| distrib-zones | distribution zones | `list(string)` | n/a | no |
| inst-group-region | region of instance group | `string` | n/a | no |
| named-port-name | name of the named port | `string` | n/a | yes |
| named-port-port | port of the named port | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| wp-inst-group-id | id of instance groups |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
