resource "aws_iam_role" "tf-eks-cluster" {
  name = "tf-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "tf-eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.tf-eks-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "tf-eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.tf-eks-cluster.name}"
}

resource "aws_security_group" "tf-eks-cluster" {
  name        = "tf-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.tf-eks.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-eks"
  }
}

resource "aws_security_group_rule" "tf-eks-cluster-ingress-node-http" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.tf-eks-cluster.id}"
  source_security_group_id = "${aws_security_group.tf-eks-node.id}"
  to_port                  = 80
  type                     = "ingress"
}

resource "aws_security_group_rule" "tf-eks-cluster-ingress-workstation-http" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.tf-eks-cluster.id}"
  to_port           = 80
  type              = "ingress"
}

resource "aws_eks_cluster" "tf-eks" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.tf-eks-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.tf-eks-cluster.id}"]
    subnet_ids         = "${aws_subnet.tf-eks[*].id}"
  }

  depends_on = [
    "aws_iam_role_policy_attachment.tf-eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.tf-eks-cluster-AmazonEKSServicePolicy",
  ]
}