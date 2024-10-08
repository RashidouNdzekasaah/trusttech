# Security Group for the Bastion Host (if not already created)
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id
  name   = "bastion-security-group"

  # Allow SSH access from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-security-group"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0866a3c8686eaeeba" # Replace with your preferred AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1.id
  key_name                    = "devkey"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}