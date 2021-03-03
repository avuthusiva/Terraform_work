resource "aws_iam_role" "Terraform_iam_role" {
  name = "terraform-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com","ecs-tasks.amazonaws.com","ecs.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "Terraform_iam_role"
  }
}

resource "aws_iam_role_policy" "Terraform_iam_role_policy" {
  name = "terraform-iam-role-policy"
  role = "${aws_iam_role.Terraform_iam_role.id}"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:*",
          "ecs:*",
          "ecr:*",
          "sns:*",
          "logs:*",
          "cloudwatch:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}
