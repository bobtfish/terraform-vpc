output "region" {
  value = "${var.region}"
}
output "account" {
  value = "${var.account}"
}
output "azs" {
  value = "${module.azs.list_all}"
}
output "az_count" {
  value = "${module.azs.count}"
}
output "frontsubnets"
  value = "${join(\",\", aws_subnet.front.*.id)}"
}
output "dedicatedsubnets" {
    value = "${join(\",\", aws_subnet.back.*.id)}"
}
output "ephemeralsubnets" {
    value = "${join(\",\", aws_subnet.ephemeral.*.id)}"
}
output "public-routetable" {
    value = "${aws_route_table.public.id}"
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

