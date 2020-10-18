//-----> Storing public ip of instance in file.

output "myos_ip" {
  value = aws_instance.OS1.public_ip
}

resource "null_resource" "ip_store" {
  provisioner "local-exec" {
    command = "echo  ${aws_instance.OS1.public_ip} > publicip.txt"
  }
}

//-----------------------------------------------------------------------------
// Storing Cloud front domain name in file.


resource "null_resource" "domain-name" {
  provisioner "local-exec" {
    command = "echo  ${aws_cloudfront_distribution.s3_distribution.domain_name}/webphoto.html > cloudfront-domain-name.txt"
  }
}


//----------------------------------------------------------------------------
// Output Shows in chrome

resource "null_resource" "Output" {
  depends_on = [
    null_resource.mount-ebs, aws_cloudfront_distribution.s3_distribution
  ]

  provisioner "local-exec" {
    command = "start chrome  ${aws_instance.OS1.public_ip}"
  }
}