output "instance_arn" {
  value = aws_instance.public_ec2.arn
}

output "public_ip_address" {
  value = aws_instance.public_ec2.public_ip
}

output "private_ip_address" {
  value = aws_instance.public_ec2.private_ip
}

output "instance_id" {
  value = aws_instance.public_ec2.id
}

output "public_dns_name" {
  value = aws_instance.public_ec2.public_dns
}


output "placement_group_arn" {
  value = aws_placement_group.test_pg.arn
}

output "placement_group_id" {
  value = aws_placement_group.test_pg.id
}

output "ebs_volume_id" {
  value = aws_ebs_volume.test_volume.id
}

output "file_system_id" {
  value = aws_efs_file_system.test_file_system_with_lifecycle_policy.id
}
