//-----> Giving Security Protocol
resource "aws_security_group" "firewall" {
  name = "Hitesh-terraform-firewall"
  vpc_id      = "vpc-608d9b08"
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Firewall"
  }

}

// sg for efs ec2 instances in 1a,1b,1c
resource "aws_security_group" "efs_sg" {
  name = "Hitesh-terraform-efs-sg"
  vpc_id      = "vpc-608d9b08"
  ingress {
    description = "nfs"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}