# create SSH key for root user in VULTR
resource "vultr_ssh_key" "k3s_master_instance" {
  name                  = "${var.instance_prefix}-root"
  ssh_key               = tls_private_key.root_tls_key.public_key_openssh
}
# create k3s mqster
resource "vultr_instance" "k3s_master_instance" {
  plan                  = var.vultr_instance_plan
  region                = var.vultr_instance_region
# os_id                 = var.vultr_instance_os_id
  app_id                = var.vultr_instance_app_id
  label                 = "${var.instance_prefix}-master"
  hostname              = "${var.instance_prefix}-master"
  tag                   = var.instance_prefix
  ssh_key_ids           = [ vultr_ssh_key.instance.id ]

  enable_ipv6           = false

  # don't send activation emails
  activation_email      = false

  # connection will use generated ssh key for root user
  connection {
      host        = self.main_ip
      type        = "ssh"
      user        = "root"
      private_key = file(local_file.root_key.filename)
  }

  # perform a system upgrade
# provisioner "remote-exec" {
#   inline = [
#     "sudo apt-get update -y",
#     "sudo apt-get dist-upgrade -y",
#   ]
# }

# # add the guest user
# provisioner "remote-exec" {
#   inline = [
#     "sudo /usr/sbin/groupadd ${var.instance_user}",
#     "sudo /usr/sbin/useradd  ${var.instance_user} -g  ${var.instance_user} -G sudo -d /home/${var.instance_user} --shell /bin/bash --create-home",
#     "sudo bash -ic 'echo \"${var.instance_user}:${random_password.instance_user_password.result}\" | chpasswd'",
#     "sudo bash -ic 'echo \"${var.instance_user}        ALL=(ALL)       NOPASSWD: ALL\" >> /etc/sudoers.d/${var.instance_user}'",
#     "sudo chmod 440 /etc/sudoers.d/${var.instance_user}",
#     "sudo mkdir /home/${var.instance_user}/.ssh",
#     "sudo chmod 700 /home/${var.instance_user}/.ssh",
#     "sudo bash -ic 'echo \"${tls_private_key.instance_user_tls_key.public_key_openssh}\" > /home/${var.instance_user}/.ssh/authorized_keys'",
#     "sudo chmod 600 /home/${var.instance_user}/.ssh/authorized_keys",
#     "sudo chown -R ${var.instance_user}:${var.instance_user} /home/${var.instance_user}/.ssh"
#   ]
# }

  provisioner "local-exec" {
    command = <<EOT
            k3sup install \
            --ip ${self.main_ip} \
            --context k3s \
            --ssh-key ${local_file.root_key.filename} \
            --user root
        EOT
  }



}
resource "vultr_ssh_key" "instance" {
  name                  = "${var.instance_prefix}-root"
  ssh_key               = tls_private_key.root_tls_key.public_key_openssh
}

# create VULTR instance(s)
resource "vultr_instance" "instance" {
  count                 = var.bot_count
  plan                  = var.vultr_instance_plan
  region                = var.vultr_instance_region
  # os_id                 = var.vultr_instance_os_id
  app_id                = var.vultr_instance_app_id
  label                 = "${var.instance_prefix}${format("%02d", count.index + 1)}"
  hostname              = "${var.instance_prefix}${format("%02d", count.index + 1)}"
  tag                   = var.instance_prefix
  ssh_key_ids           = [ vultr_ssh_key.instance.id ]

  enable_ipv6           = false

  # don't send activation emails
  activation_email      = false

  # connection will use generated ssh key for root user
  connection {
      host        = self.main_ip
      type        = "ssh"
      user        = "root"
      private_key = file(local_file.root_key.filename)
  }

  # perform a system upgrade
 # provisioner "remote-exec" {
 #   inline = [
 #     "sudo apt-get update -y",
 #     "sudo apt-get dist-upgrade -y",
 #   ]
 # }

 # # add the guest user
 # provisioner "remote-exec" {
 #   inline = [
 #     "sudo /usr/sbin/groupadd ${var.instance_user}",
 #     "sudo /usr/sbin/useradd  ${var.instance_user} -g  ${var.instance_user} -G sudo -d /home/${var.instance_user} --shell /bin/bash --create-home",
 #     "sudo bash -ic 'echo \"${var.instance_user}:${random_password.instance_user_password.result}\" | chpasswd'",
 #     "sudo bash -ic 'echo \"${var.instance_user}        ALL=(ALL)       NOPASSWD: ALL\" >> /etc/sudoers.d/${var.instance_user}'",
 #     "sudo chmod 440 /etc/sudoers.d/${var.instance_user}",
 #     "sudo mkdir /home/${var.instance_user}/.ssh",
 #     "sudo chmod 700 /home/${var.instance_user}/.ssh",
 #     "sudo bash -ic 'echo \"${tls_private_key.instance_user_tls_key.public_key_openssh}\" > /home/${var.instance_user}/.ssh/authorized_keys'",
 #     "sudo chmod 600 /home/${var.instance_user}/.ssh/authorized_keys",
 #     "sudo chown -R ${var.instance_user}:${var.instance_user} /home/${var.instance_user}/.ssh"
 #   ]
 # }

 provisioner "local-exec" {
    command = <<EOT
            k3sup join \
            --ip ${self.main_ip} \
            --server-ip ${vultr_instance.k3s_master_instance.main_ip} \
            --ssh-key ${local_file.root_key.filename} \
            --user root
        EOT
  }
}
