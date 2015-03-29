output "primary-az-frontsubnet" {
  value = "${aws_subnet.front-primary.id}"
}
output "primary-az-dedicatedsubnet" {
    value = "${aws_subnet.back-primary.id}"
}
output "primary-az-ephemeralsubnet" {
    value = "${aws_subnet.ephemeral-primary.id}"
}
output "secondary-az-frontsubnet" {
    value = "${aws_subnet.front-secondary.id}"
}
output "secondary-az-dedicatedsubnet" {
    value = "${aws_subnet.back-secondary.id}"
}
output "secondary-az-ephemeralsubnet" {
    value = "${aws_subnet.ephemeral-secondary.id}"
}
output "public-routeable" {
    value = "${aws_routetable.public.id}"
}
output "id" {
    value = "${aws_vpc.main.id}"
}
output "cidr_block" {
    value = "${aws_vpc.main.cidr_block}"
}
output "main_route_table_id" {
    value = "${aws_vpc.main.main_route_table_id}"
}
output "default_network_acl_id" {
    value = "${aws_vpc.main.default_network_acl_id}"
}
output "default_security_group_id" {
    value = "${aws_vpc.main.default_security_group_id}"
}

