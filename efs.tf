// Creating an efs service in 1a,1b,1c

resource "aws_efs_file_system" "create_efs" {
  creation_token = "my_efs"

  tags = {
    Name = "efs"
  }
}


resource "aws_efs_access_point" "efs_access" {

depends_on = [
   aws_efs_file_system.create_efs,
  ]

  file_system_id = aws_efs_file_system.create_efs.id
}


resource "aws_efs_mount_target" "alpha" {

depends_on = [
   aws_efs_file_system.create_efs,
   aws_security_group.efs_sg,
  ]
  file_system_id = aws_efs_file_system.create_efs.id
  subnet_id      = aws_instance.OS1.subnet_id
  security_groups = [aws_security_group.efs_sg.id, 
                     aws_security_group.firewall.id ]
}


// Attaching EFS with instance
resource "null_resource" "mount-ebs" {

  depends_on = [
    aws_efs_mount_target.alpha,
  ]


  connection {
    type        = "ssh"
    user        = "ec2-user"
    port        =  22
    private_key = file("C:/Users/hites/Downloads/cloud.pem")
    host        = aws_instance.OS1.public_ip
  }

  provisioner "remote-exec" {
    inline = [
     // "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_mount_target.alpha.mount_target_dns_name}:/ /var/www/html",
     // "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.create_efs.id}.efs.ap-south-1.amazonaws.com:/ /var/www/html",
      "sudo mount -t efs -o tls ${aws_efs_file_system.create_efs.id}:/ /var/www/html",
      "sudo /usr/sbin/httpd",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/pk2101/automation.git /var/www/html/"
    ]
  }
}

