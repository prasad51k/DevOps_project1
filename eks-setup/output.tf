output "public_ip_of_eks_server" {
    description = "this is the public IP"
    value = aws_instance.server-1.public_ip
}

output "private_ip_of_eks_server" {
    description = "this is the public IP"
    value = aws_instance.server-1.private_ip
}