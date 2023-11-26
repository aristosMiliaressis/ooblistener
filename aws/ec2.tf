data "aws_ami" "this" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ooblistener-*"]
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.key_name
}

resource "aws_key_pair" "this" {
  key_name   = "oob-listener"
  public_key = var.public_key
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
      from_port        = 389
      to_port          = 389
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "allow-ldap"
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