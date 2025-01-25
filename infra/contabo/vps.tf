resource "contabo_instance" "this" {
  display_name = "ooblistener"
  product_id   = "V45"
  region       = "EU"
  period       = 1
  ssh_keys     = [contabo_secret.ssh_key.id]

  provisioner "local-exec" {
    command = "sleep 10; ssh-keyscan -H ${self.ip_config[0].v4[0].ip} | anew ~/.ssh/known_hosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u admin -i '${self.ip_config[0].v4[0].ip},' --key-file ${local_file.private_key.filename} ../../conf/ansible/build.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u admin -i '${self.ip_config[0].v4[0].ip},' --key-file ${local_file.private_key.filename} --extra-vars \"domain=${var.domain}\" ../../conf/ansible/start.yml"
  }
}

### SSH Key Pair
data "external" "local_home" {
  program = ["bash", "-c", "echo $HOME | jq --raw-input '. | { home: (.) }'"]
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${data.external.local_home.result.home}/.ssh/ooblistener"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content         = tls_private_key.ssh.public_key_openssh
  filename        = "${data.external.local_home.result.home}/.ssh/ooblistener.pub"
  file_permission = "0644"
}

resource "contabo_secret" "ssh_key" {
  name  = "ooblistener"
  value = tls_private_key.ssh.public_key_openssh
  type  = "ssh"
}
