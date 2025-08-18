resource "aws_instance" "vpc2_web" {
  count         = var.instance_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.vpc2_private_subnet_ids[count.index]

  vpc_security_group_ids = [var.vpc2_web_sg_id]
  key_name               = var.key_name

user_data = base64encode(<<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>VPC2 Production Web Server ${count.index + 1}</h1>" > /var/www/html/index.html
echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
echo "<p>VPC: VPC2 (Production)</p>" >> /var/www/html/index.html
EOF
  )

  tags = {
    Name        = "${var.environment}-vpc2-web-instance-${count.index + 1}"
    Environment = var.environment
    VPC         = "VPC2-Production"
  }
}

resource "aws_instance" "vpc1_bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.vpc1_public_subnet_id
  vpc_security_group_ids      = [var.vpc1_bastion_sg_id]
  key_name                   = var.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "${var.environment}-vpc1-bastion-host"
    Environment = var.environment
    VPC         = "VPC1-Management"
  }
}

resource "aws_instance" "vpc1_database" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.vpc1_private_subnet_ids[0]

  vpc_security_group_ids = [var.vpc1_database_sg_id]
  key_name               = var.key_name

  user_data = base64encode(<<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y mysql-server
systemctl start mysql
systemctl enable mysql
EOF
  )

  tags = {
    Name        = "${var.environment}-vpc1-database-server"
    Environment = var.environment
    VPC         = "VPC1-Management"
  }
}
