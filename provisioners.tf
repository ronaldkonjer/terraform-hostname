/*
 * hostname provisioners
 */

resource "null_resource" "sethostname-proxy" {
  count = local.use_proxy ? var.hcount : 0
  triggers = {
    fqdn    = var.fqdns[count.index]
    address = var.addresses[count.index]
  }
  connection {
    host                = var.addresses[count.index]
    user                = var.user
    private_key         = local.private_key
    bastion_host        = var.bastion
    bastion_user        = var.bastion_user
    bastion_private_key = local.bastion_private_key
  }
  provisioner "file" {
    source      = "${path.module}/scripts/sethostname.sh"
    destination = "/tmp/sethostname.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/sethostname.sh",
      "sudo /tmp/sethostname.sh ${var.fqdns[count.index]}",
      "rm /tmp/sethostname.sh",
    ]
  }
}

resource "null_resource" "sethostname-direct" {
  count = false == local.use_proxy ? var.hcount : 0
  triggers = {
    fqdn    = var.fqdns[count.index]
    address = var.addresses[count.index]
  }
  connection {
    host        = var.addresses[count.index]
    user        = var.user
    private_key = local.private_key
  }
  provisioner "file" {
    source      = "${path.module}/scripts/sethostname.sh"
    destination = "/tmp/sethostname.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/sethostname.sh",
      "sudo /tmp/sethostname.sh ${var.fqdns[count.index]}",
      "rm /tmp/sethostname.sh",
    ]
  }
}

