rds_identifier        = "mysql"
rds_engine            = "mysql"
rds_engine_version    = "8.0.15"
rds_instance_class    = "db.t2.micro"
rds_allocated_storage = 10
rds_storage_encrypted = false     
rds_name              = "username"        
rds_username          = "admin"  

rds_port                    = 3306
rds_maintenance_window      = ""
rds_backup_window           = ""
rds_backup_retention_period = 1
rds_publicly_accessible     = false

rds_final_snapshot_identifier = "prod-trademerch-website-db-snapshot"
rds_snapshot_identifier       = null # used to recover from a snapshot

rds_performance_insights_enabled  = true


resource "random_string" "password" {
  length  = 16
  special = false
}



resource "aws_security_group" "hellords" {
  name = "${local.resource_name_prefix}-rds-sg"

  description = "RDS (terraform-managed)"
  vpc_id      = var.rds_vpc_id

  
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr_block
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_egress_cidr_block
  }
}