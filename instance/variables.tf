variable "amid" {
  default=""
  description = "Ami ID"
}
variable "instance_type" {
  
}
variable "tags" {

}
 variable "ingress_rules" {
   
 }
 variable "sg_name" {
   
 }
 variable "bucket_name" {
   default="backend-terraform-bramdon2"
 }
 variable "acl" {
   default="private"
 }
variable "tags_s3" {
   default={
     Enviroment="Dev",
     CreatedBy="Terraform"
   }
 }