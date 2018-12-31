/*
 * hostname local variables
 */

locals {
  use_proxy = "${length(var.bastion) > 0 ? true : false}"
  private_key = "${file(var.private_key_path)}"
  bastion_private_key_path = "${length(var.bastion_private_key_path) > 0 ? var.bastion_private_key_path : "/dev/null"}"
  bastion_private_key = "${file(local.bastion_private_key_path)}"
}
