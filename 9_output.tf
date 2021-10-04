output "k3s_master" {

  description = "The default IP address of the k3s controller."
  value = tomap( { "${vultr_instance.k3s_master_instance.hostname}" = vultr_instance.k3s_master_instance.main_ip })
}
output "k3s_nodes" {
  description = "The default IP address of each node deployed, indexed by name."
  value = zipmap(
    flatten(tolist(
      vultr_instance.instance.*.hostname,
    )),
    flatten(tolist(
      vultr_instance.instance.*.main_ip,
    )),
  )
}

output "instance_user" {
  description = "instance(s) user login"
  value = var.instance_user
}

output "instance_user_password" {
  description = "instance(s) user password"
  value = random_password.instance_user_password.result
  sensitive = true
}
