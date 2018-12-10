/*
 * hostname outputs
 */

output "resource_ids" {
  value = "${concat(null_resource.sethostname-direct.*.id, null_resource.sethostname-proxy.*.id)}"
}