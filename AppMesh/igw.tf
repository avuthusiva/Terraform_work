resource "aws_internet_gateway" "Terraform_IGW" {
  vpc_id = "${aws_vpc.Terraform_VPC.id}"
  tags = {
    Name = "${var.igw_name}_${var.env}"
  }
  depends_on = ["aws_vpc.Terraform_VPC"]
}
