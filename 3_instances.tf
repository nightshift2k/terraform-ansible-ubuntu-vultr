# create SSH key for root user in VULTR
resource "vultr_ssh_key" "instance" {
  name    = "${var.instance_prefix}-root"
  ssh_key = tls_private_key.root_tls_key.public_key_openssh
}

# create VULTR instance(s)
resource "vultr_instance" "instance" {
  count       = var.instance_count
  plan        = var.vultr_instance_plan
  region      = var.vultr_instance_region
  os_id       = var.vultr_instance_os_id
  label       = "${var.instance_prefix}${format("%02d", count.index + 1)}"
  hostname    = "${var.instance_prefix}${format("%02d", count.index + 1)}"
  tag         = var.instance_prefix
  ssh_key_ids = [vultr_ssh_key.instance.id]
  enable_ipv6 = false

  # don't send activation emails
  activation_email = false

  # connection will use generated ssh key for root user
  connection {
    host        = self.main_ip
    type        = "ssh"
    user        = "root"
    private_key = file(local_file.root_key.filename)
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
    "/tmp/script.sh '${var.instance_user}' '${chomp(data.local_file.instance_user_key.content)}' '${random_password.instance_user_password.result}'", ]

  }

}
