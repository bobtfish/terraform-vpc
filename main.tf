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
    source = "github.com/bobtfish/terraform-azs"
    account = "${var.account}"
    region = "${var.region}"
}

resource "aws_subnet" "front-primary" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${module.azs.primary}"

    tags {
        Name = "primary az front dedicated"
    }
}

resource "aws_route_table_association" "front-primary" {
    subnet_id = "${aws_subnet.front-primary.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "back-primary" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.1.0/24"
    availability_zone = "${module.azs.primary}"

    tags {
        Name = "primary az back dedicated"
    }
}

resource "aws_subnet" "front-secondary" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${module.azs.secondary}"

    tags {
        Name = "secondary az front dedicated"
    }
}

resource "aws_route_table_association" "front-secondary" {
    subnet_id = "${aws_subnet.front-secondary.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "back-secondary" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.3.0/24"
    availability_zone = "${module.azs.secondary}"

    tags {
        Name = "secondary az back dedicated"
    }
}

resource "aws_subnet" "ephemeral-primary" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.64.0/28"
    availability_zone = "${module.azs.primary}"

    tags {
        Name = "primary az back ephemeral"
    }
}

resource "aws_subnet" "ephemeral-secondary" {
  vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.networkprefix}.128.0/28"
    availability_zone = "${module.azs.secondary}"

    tags {
        Name = "secondary az back ephemeral"
    }
}
