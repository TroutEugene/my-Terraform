<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.private_ip_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_sql_database.main-database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.main-instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.users](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_type"></a> [address\_type](#input\_address\_type) | type of address | `string` | `"INTERNAL"` | no |
| <a name="input_backup_config"></a> [backup\_config](#input\_backup\_config) | n/a | `map` | `{}` | no |
| <a name="input_database-name"></a> [database-name](#input\_database-name) | name of the database | `string` | n/a | yes |
| <a name="input_database-region"></a> [database-region](#input\_database-region) | region of the database | `string` | n/a | yes |
| <a name="input_database-size"></a> [database-size](#input\_database-size) | size of the database | `string` | n/a | yes |
| <a name="input_database-version"></a> [database-version](#input\_database-version) | version of the database | `string` | n/a | yes |
| <a name="input_db-instance-name"></a> [db-instance-name](#input\_db-instance-name) | name of the database instance | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | password | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | username | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | n/a | `string` | `"false"` | no |
| <a name="input_disk_autoresize"></a> [disk\_autoresize](#input\_disk\_autoresize) | n/a | `string` | `"true"` | no |
| <a name="input_disk_autoresize_limit"></a> [disk\_autoresize\_limit](#input\_disk\_autoresize\_limit) | n/a | `string` | `"10"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | n/a | `string` | `"100"` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | n/a | `string` | `"PD_SSD"` | no |
| <a name="input_ipv4_enabled"></a> [ipv4\_enabled](#input\_ipv4\_enabled) | n/a | `string` | `"false"` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | n/a | `string` | n/a | yes |
| <a name="input_private-ip-ad"></a> [private-ip-ad](#input\_private-ip-ad) | private ip address of database | `string` | n/a | yes |
| <a name="input_private-ip-ad-name"></a> [private-ip-ad-name](#input\_private-ip-ad-name) | name of the private ip address of database | `string` | n/a | yes |
| <a name="input_private-ip-ad-prefix"></a> [private-ip-ad-prefix](#input\_private-ip-ad-prefix) | prefix of private ip address of database | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | private ip purpose description | `string` | `"VPC_PEERING"` | no |
| <a name="input_require_ssl"></a> [require\_ssl](#input\_require\_ssl) | n/a | `string` | `"false"` | no |
| <a name="input_service_networking"></a> [service\_networking](#input\_service\_networking) | networking connection service | `string` | `"servicenetworking.googleapis.com"` | no |
| <a name="input_sql_activation_policy"></a> [sql\_activation\_policy](#input\_sql\_activation\_policy) | activation policy for sql db | `string` | `"ALWAYS"` | no |
| <a name="input_sql_availability_type"></a> [sql\_availability\_type](#input\_sql\_availability\_type) | availabiltiy type of sql db | `string` | `"REGIONAL"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->