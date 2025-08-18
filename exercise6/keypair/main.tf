resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "${var.environment}-generated-key-pair"
  public_key = tls_private_key.generated_key.public_key_openssh

  tags = {
    Name        = "${var.environment}-generated-key-pair"
    Environment = var.environment
  }
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.generated_key.private_key_pem
  filename        = "${path.root}/${var.environment}-private-key.pem"
  file_permission = "0600"
}
