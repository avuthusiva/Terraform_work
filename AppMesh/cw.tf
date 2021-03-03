resource "aws_cloudwatch_log_group" "Terraform_log_group" {
  name = "terraform_ecs_task"

  tags = {
    Name = "Terraform_log_group"
  }
}
