
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "terraform-generated-key"
  public_key = tls_private_key.generated_key.public_key_openssh

  tags = {
    Name        = "terraform-generated-key"
    Environment = var.environment
  }
}


resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.generated_key.private_key_pem
  filename        = "${path.root}/private_key.pem"
  file_permission = "0600"
}


resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.bastion_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                   = aws_key_pair.generated.key_name
  associate_public_ip_address = true

  # User data to copy private key to bastion host for accessing private instances
user_data = base64encode(<<-EOF
#!/bin/bash
# Create .ssh directory if it doesn't exist
mkdir -p /home/ubuntu/.ssh
echo '${tls_private_key.generated_key.private_key_pem}' > /home/ubuntu/.ssh/private_key.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/private_key.pem
chmod 600 /home/ubuntu/.ssh/private_key.pem
apt-get update
apt-get install -y curl wget
systemctl start ssh
systemctl enable ssh
EOF
)

  tags = {
    Name        = "${var.environment}-bastion-host"
    Environment = var.environment
  }
}
