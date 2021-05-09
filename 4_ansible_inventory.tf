# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
  {
    instances = zipmap(
        flatten(list(
            vultr_instance.instance.*.hostname,
        )),
        flatten(list(
            vultr_instance.instance.*.main_ip,
        )),
    )
    ansible_user_name = var.instance_user
    ansible_user_password = random_password.instance_user_password.result
    ansible_ssh_private_key_file = local_file.instance_user_key.filename
  })
  filename = "${abspath(path.root)}/output/hosts.cfg"
  file_permission = "0600"
}