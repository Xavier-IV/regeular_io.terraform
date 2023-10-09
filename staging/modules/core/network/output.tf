output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_az1_id" {
  value = aws_subnet.subnet_private_az1.id
}

output "private_subnet_az2_id" {
  value = aws_subnet.subnet_private_az2.id
}

output "public_subnet_ecs_az1_id" {
  value = aws_subnet.subnet_ecs_az1.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.subnet_public_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.subnet_public_az2.id
}

#output "private_subnet_with_nat_id" {
#  value = aws_subnet.private.id
#}

output "sg_id" {
  value = aws_security_group.sg.id
}

output "sg_vpn_id" {
  value = aws_security_group.sg_vpn.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}