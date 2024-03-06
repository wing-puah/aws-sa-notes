output "instance_arn" {
  value = aws_instance.test_ec2.arn
}

output "public_ip_address" {
  value = aws_instance.test_ec2.public_ip
}

output "private_ip_address" {
  value = aws_instance.test_ec2.private_ip
}

output "instance_id" {
  value = aws_instance.test_ec2.id
}

output "public_dns_name" {
  value = aws_instance.test_ec2.public_dns
}

output "security_group_id" {
  value = aws_security_group.test_sg.id
}

output "security_group_arn" {
  value = aws_security_group.test_sg.arn
}

output "placement_group_arn" {
  value = aws_placement_group.test_pg.arn
}

output "placement_group_id" {
  value = aws_placement_group.test_pg.id
}
