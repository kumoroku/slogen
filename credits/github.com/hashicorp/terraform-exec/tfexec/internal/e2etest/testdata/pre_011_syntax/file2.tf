data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_vpc" "test" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
}

resource "aws_subnet" "test" {
  count  = 2
  vpc_id = "${aws_vpc.test.id}"

  cidr_block        = "${cidrsubnet(var.vpc_cidr, 2, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}
