rds_identifier        = "mysql"
rds_engine            = "mysql"
rds_engine_version    = "8.0.15"
rds_instance_class    = "db.t2.micro"
rds_allocated_storage = 10
rds_storage_encrypted = false     # not supported for db.t2.micro instance
rds_name              = ""        # use empty string to start without a database created
rds_username          = "admin"   # rds_password is generated

rds_port                    = 3306
rds_maintenance_window      = "Mon:00:00-Mon:03:00"
rds_backup_window           = "10:46-11:16"
rds_backup_retention_period = 1
rds_publicly_accessible     = false

rds_final_snapshot_identifier = "prod-trademerch-website-db-snapshot" # name of the final snapshot after deletion
rds_snapshot_identifier       = null # used to recover from a snapshot

rds_performance_insights_enabled  = true


resource "random_string" "password" {
  length  = 16
  special = false
}



resource "aws_security_group" "_" {
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