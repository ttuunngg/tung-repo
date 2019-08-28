resource "aws_vpc" "tf-eks" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "tf-eks-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "tf-eks" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.tf-eks.id}"

  tags = "${
    map(
      "Name", "tf-eks-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "tf-eks" {
  vpc_id = "${aws_vpc.tf-eks.id}"

  tags = {
    Name = "tf-eks"
  }
}

resource "aws_route_table" "tf-eks" {
  vpc_id = "${aws_vpc.tf-eks.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf-eks.id}"
  }
}

resource "aws_route_table_association" "tf-eks" {
  count = 2

  subnet_id      = "${aws_subnet.tf-eks.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf-eks.id}"
}