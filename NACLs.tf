# NACL for Public Subnets
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-nacl"
  }
}

# Inbound Rules for Public NACL
resource "aws_network_acl_rule" "allow_http_public" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  protocol       = "6" # TCP
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "allow_https_public" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  protocol       = "6" # TCP
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "allow_ssh_public" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 120
  protocol       = "6" # TCP
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0" # Replace with your specific IP if you want to restrict SSH
  from_port      = 22
  to_port        = 22
}

# Allow all inbound traffic
resource "aws_network_acl_rule" "allow_all_inbound" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 101
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}


# Outbound Rule for Public NACL - Allow All
resource "aws_network_acl_rule" "allow_all_outbound_public" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

# NACL for Private Subnets
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-nacl"
  }
}

# Inbound Rules for Private NACL - Allow Database Port
resource "aws_network_acl_rule" "allow_db_private" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  protocol       = "6" # TCP
  rule_action    = "allow"
  egress         = false
  cidr_block     = "10.0.1.0/24" # Public Subnet CIDR
  from_port      = 3306
  to_port        = 3306
}

# Outbound Rule for Private NACL - Allow All
resource "aws_network_acl_rule" "allow_all_outbound_private" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

# NACL Associations for Public Subnets
resource "aws_network_acl_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  network_acl_id = aws_network_acl.public_nacl.id
}

# NACL Associations for Private Subnets
resource "aws_network_acl_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  network_acl_id = aws_network_acl.private_nacl.id
}

resource "aws_network_acl_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  network_acl_id = aws_network_acl.private_nacl.id
}
