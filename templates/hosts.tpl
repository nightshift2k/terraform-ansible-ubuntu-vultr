%{ for name, ip in instances ~}
[${replace(name, "-","_")}]
${name} ansible_host=${ip}
%{ endfor ~}

[all:vars]
ansible_connection=ssh
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_user=${ansible_user_name}
ansible_pass=${ansible_user_password}
ansible_ssh_private_key_file=${ansible_ssh_private_key_file}
