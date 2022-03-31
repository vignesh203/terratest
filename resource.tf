resource "aws_key_pair" "new" {
  key_name   = "${var.project}-packiya"
  public_key = var.aws_key_pair
}
resource "aws_security_group" "allow_tls" {
  name        = "${var.project}-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.new.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = var.subnet_id

  tags = {
    Name = "${var.project}-instancename"
  }
}