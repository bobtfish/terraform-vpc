resource "aws_vpc" "main" {
    cidr_block = "${var.networkprefix}.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
        Name = "${var.region} ${var.account} main"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.region}-${var.account}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "${var.region} ${var.account} public"
    }
}

module "azs" {
    source = "github.com/terraform-community-modules/tf_aws_availability_zones"
    account = "${var.account}"
    region = "${var.region}"
}

resource "aws_subnet" "front" {
    count = "${module.azs.az_count}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.${count.index}.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${element(split(\",\", module.azs.list_all), count.index)}"

    tags {
        Name = "az ${count.index} front dedicated"
    }
}

resource "aws_route_table_association" "front" {
    count = "${module.azs.az_count}"
    subnet_id = "${element(aws_subnet.front.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "back" {
    count = "${module.azs.az_count}"
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.${(count.index+10}.0/24"
    availability_zone = "${element(split(\",\", module.azs.list_all), count.index)}"

    tags {
        Name = "az ${count.index} back dedicated"
    }
}

resource "aws_subnet" "ephemeral" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.${64*(count.index+1)}.0/18"
    availability_zone = "${element(split(\",\", module.azs.list_all), count.index)}"

    tags {
        Name = "az ${count.index} back ephemeral"
    }
}

