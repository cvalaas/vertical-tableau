module "worker" {
  source            = "github.com/nubisproject/nubis-terraform//worker?ref=v2.0.1"
  region            = "${var.region}"
  environment       = "${var.environment}"
  account           = "${var.account}"
  service_name      = "${var.service_name}"
  purpose           = "webserver"
  ami               = "${var.ami}"
  elb               = "${module.load_balancer.name}"
  ssh_key_file      = "${var.ssh_key_file}"
  ssh_key_name      = "${var.ssh_key_name}"
  nubis_sudo_groups = "${var.nubis_sudo_groups}"
  nubis_user_groups = "${var.nubis_user_groups}"

  security_group        = "${data.consul_keys.vertical.var.client_security_group_id}"
  security_group_custom = true

  instance_type = "c4.xlarge"

  health_check_type = "EC2"

  root_storage_size = "256"
}

module "load_balancer" {
  source              = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v2.1.0"
  region              = "${var.region}"
  environment         = "${var.environment}"
  account             = "${var.account}"
  service_name        = "${var.service_name}"
}

module "dns" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v2.1.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer.address}"
}
