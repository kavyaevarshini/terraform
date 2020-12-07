locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
}



module "ec2" {
  source = "../../modules/ec2"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  ami           = "ami-07ebfd5b3428b6f4d" # Ubuntu Server 18.04 LTS
  key_name      = "${local.resource_name_prefix}-ec2-key"
  instance_type = t2.micro
  subnet_id     = module.subnet_ec2.ids[0]

  vpc_security_group_ids = [aws_security_group.ec2.id]

  vpc_id = "${aws_vpc.main.id}"
}






