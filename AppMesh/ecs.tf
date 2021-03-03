resource "aws_ecs_cluster" "Terraform_ecs_cluster" {
  name = "${var.cluster_name}"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
  tags = {
      Name = "${var.cluster_name}_${var.env}"
  }
}

resource "aws_ecs_service" "Terraform_ECS_Serivce_service_discovery" {
  name                = "appmesh-notification"
  cluster             = "${aws_ecs_cluster.Terraform_ecs_cluster.id}"
  task_definition     = "${aws_ecs_task_definition.Terraform_ecs_task_definition.arn}"
  scheduling_strategy = "REPLICA"
  desired_count = 1
#  iam_role = "${aws_iam_role.Terraform_iam_role.arn}"
  launch_type = "FARGATE"
  platform_version = "LATEST"
  force_new_deployment = true
#  health_check_grace_period_seconds = "147"
  network_configuration {
      subnets = "${aws_subnet.Terraform_Public_Subnets.*.id}"
      security_groups = ["${aws_security_group.Terraform_security_group.id}"]
      assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
  service_registries {
    registry_arn = "${aws_service_discovery_service.Terraform_service_discovery_service.arn}"
#    container_port = "8096"
#    port = "8096"
  }
  depends_on = ["aws_ecs_cluster.Terraform_ecs_cluster"]
}

resource "aws_ecs_service" "Terraform_ECS_Serivce_usermgmt" {
  name                = "appmesh-usermanagement"
  cluster             = "${aws_ecs_cluster.Terraform_ecs_cluster.id}"
  task_definition     = "${aws_ecs_task_definition.Terraform_ecs_task_definition_usermgmt.arn}"
  scheduling_strategy = "REPLICA"
  desired_count = 1
#  iam_role = "${aws_iam_role.Terraform_iam_role.arn}"
  launch_type = "FARGATE"
  platform_version = "LATEST"
  force_new_deployment = true
  health_check_grace_period_seconds = "147"
  network_configuration {
      subnets = "${aws_subnet.Terraform_Public_Subnets.*.id}"
      security_groups = ["${aws_security_group.Terraform_security_group.id}"]
      assign_public_ip = true
  }
  load_balancer {
#    elb_name = "${aws_lb.Terraform_lb.arn}"
    target_group_arn = "${aws_lb_target_group.Terraform_lb_target_group_usermgmt.arn}"
    container_name   = "usermgmt-microservice"
    container_port   = 8095
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
  service_registries {
    registry_arn = "${aws_service_discovery_service.Terraform_service_discovery_service_user.arn}"
  }
  depends_on = ["aws_ecs_cluster.Terraform_ecs_cluster","aws_lb_target_group.Terraform_lb_target_group_usermgmt","aws_lb.Terraform_lb",
              "aws_service_discovery_service.Terraform_service_discovery_service_user"]
}
