resource "tls_private_key" "root_tls_key" {
  algorithm   = "RSA"
  rsa_bits = 2048
}

resource "tls_private_key" "instance_user_tls_key" {
  algorithm   = "RSA"
  rsa_bits = 2048
}

resource "local_file" "root_key" {
  content = tls_private_key.root_tls_key.private_key_pem
  filename ="${abspath(path.root)}/ansible/root_key"
  file_permission = "0600"
}


resource "local_file" "instance_user_key" {
  content = tls_private_key.instance_user_tls_key.private_key_pem
  filename ="${abspath(path.root)}/ansible/${var.instance_user}_key"
  file_permission = "0600"
}

resource "random_password" "instance_user_password" {
  length = 12
  lower = true
  upper = true
  special = true
  override_special = "+@!#"
}