/*
 * hostname variables
 */

variable "count" {
  type = "string"
  description = "number of hosts"
}

variable "fqdns" {
  type = "list"
  description = "list of FQDNs"
}

variable "addresses" {
  type = "list"
  description = "list of either private IPs, public IPs, or public DNS names"
}

variable "user" {
  type = "string"
  description = "ssh user on the hosts"
}

variable "private_key_path" {
  type = "string"
  description = "local path to the private key for ssh access"
}

variable "bastion" {
  description = "public IP or DNS of a bastion"
  default = ""
}

variable "bastion_user" {
  description = "ssh user on the bastion"
  default = ""
}

variable "bastion_private_key_path" {
  description = "local path to the private key for bastion access"
  default = ""
}
