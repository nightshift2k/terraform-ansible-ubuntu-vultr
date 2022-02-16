output "virtual_machine_default_ips" {
  description = "The default IP address of each instance deployed, indexed by name."

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
  value       = var.instance_user
}

output "insance_user_password" {
  description = "instance(s) user password"
  value       = nonsensitive(random_password.instance_user_password.result)
}
