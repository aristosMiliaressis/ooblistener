data "hcloud_image" "this" {
  with_selector = "name==ooblistener"
  with_status   = ["available"]
  most_recent   = true
}

resource "hcloud_server" "this" {
  name         = "ooblistener"
  image        = data.hcloud_image.this.id
  server_type  = "cx11"
  ssh_keys     = [hcloud_ssh_key.this.id]
  firewall_ids = [hcloud_firewall.this.id]

  provisioner "local-exec" {
    command = "sleep 20; ssh-keyscan -H ${self.ipv4_address} | anew ~/.ssh/known_hosts"
  }
 
  provisioner "local-exec" {
    command = "ansible-playbook -u root -i '${self.ipv4_address},' --key-file ${local_file.private_key.filename} --extra-vars \"domain=${var.domain}\" ../../ansible/deploy.yml"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
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

resource "hcloud_ssh_key" "this" {
  name       = "ooblistener"
  public_key = tls_private_key.ssh.public_key_openssh
}

### Firewall Rules
resource "hcloud_firewall" "this" {
  name = "ooblistener"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "53"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

    rule {
    direction = "in"
    protocol  = "udp"
    port      = "53"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "4"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "8"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "25"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "445"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "465"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "587"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}