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

resource "aws_key_pair" "this" {
  key_name   = "ooblistener"
  public_key = tls_private_key.ssh.public_key_openssh
}

### pre-build ooblistener AMI
data "aws_ami" "this" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ooblistener-*"]
  }
}

# EC2 & security_group
resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.key_name

  provisioner "local-exec" {
    command = "sleep 10; ssh-keyscan -H ${self.public_ip} | anew ~/.ssh/known_hosts"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --key-file ${local_file.private_key.filename} --extra-vars \"domain=${var.domain}\" ../../ansible/deploy.yml"
  }
}

resource "aws_security_group" "this" {
  name = "ooblistener-sg"

  ingress = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-ssh"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 25
      to_port          = 25
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-smtp"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-dns"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 53
      to_port          = 53
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-dns-tcp"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-http"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-https"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 465
      to_port          = 465
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-smtp-autotls"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 587
      to_port          = 587
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-smtps"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 445
      to_port          = 445
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-smb"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 4
      to_port          = 4
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-https-for-interactsh"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    },
    {
      from_port        = 8
      to_port          = 8
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-http-for-interactsh"
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
