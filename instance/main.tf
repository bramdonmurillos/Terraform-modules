provider "aws"{
    region="us-east-2"
}
resource "aws_security_group" "ssh_connection" {
  name        = var.sg_name
  dynamic "ingress"{
    for_each = var.ingress_rules
    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_instance" "Tf-instance" {
  ami = var.amid
  instance_type = var.instance_type
  tags = var.tags
  security_groups = ["${aws_security_group.ssh_connection.name}"]
}
output "instance_ip" {
  value= aws_instance.Tf-instance.*.public_ip
}
resource "aws_kms_key" "bucket-key-bramdon" {
  description             = "key state file"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket" "prod-backend-bramdon" {
  bucket = var.bucket_name
  acl=var.acl
  tags=var.tags_s3
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket-key-bramdon.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}