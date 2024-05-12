# terraform workspace 
# terraform workspace new example
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
variable "tenancy_ocid" {
}
variable "user_ocid" {
}
variable "private_key_path" {
}
variable "fingerprint" {
}
variable "region" {    
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint = var.fingerprint
  region = var.region
}

# resource "oci_identity_compartment" "CreateCompartment" {
#   compartment_id = var.tenancy_ocid 
#   name           = "test"
#   description    = "test_default"
#   }
# variable "secret_ocid" {
#     default = "ocid1.vaultsecret.oc1.ap-mumbai-1.amaaaaaaaiqpj3iaw5eewnwuauyql2vhzlbd6vilpogipsh5sl7arhbax2aa"
# }
# data "oci_vault_secret" "bundle" {
#   secret_id = "ocid1.vaultsecret.oc1.ap-mumbai-1.amaaaaaaaiqpj3iaw5eewnwuauyql2vhzlbd6vilpogipsh5sl7arhbax2aa"
# }

# output "secret" {
#   value = data.oci_vault_secret.bundle
# } 

# resource "oci_database_autonomous_database" "demo_adb_21c" {
#   compartment_id              = var.compartment_ocid
#   db_name                     = "DEMO"
#   admin_password              = base64decode(data.oci_secrets_secretbundle.bundle.secret_bundle_content.0.content)
#   cpu_core_count              = 1
#   data_storage_size_in_tbs    = 1
#   db_version                  = "21c"
#   db_workload                 = "OLTP"
#   display_name                = "ADB Free Tier 21c"
#   is_free_tier                = true
#   is_mtls_connection_required = true
#   ocpu_count                  = 1
#   whitelisted_ips             = var.allowed_ip_addresses
# }



locals {
  server_names = ["backend-service-a", "backend-service-a1", "backend-service-b", "backend-service-c"]
}

output "server_names" {
  value = length(toset(local.server_names))
}


#provisioner
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}

resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = "var.root_password"
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}

resource "aws_instance" "web" {
  # ...
  connection {
    type     = "ssh"
    user     = "root"
    password = "var.root_password"
    host     = self.public_ip
  }
  # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-prod"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "MyProj" {
  type = map(object({
  name     = string
  type     = string
 }))
default = {
  "Proj1" = {
      name      = "Proj1"
      programme = "java"
   },
   "Proj2" = {
      name       = "Proj2"
      programme  = "npm"
  }
 }
}

resource "null_resource" "nullr" {
  for_each = var.MyProj
  triggers = {
    settings        = jsonencode(each.value)
    script_checksum = filesha256("/home/myscript.sh")
  }

  provisioner "local-exec" {
    command = "bash /home/myscript.sh ${each.value.name} ${each.value.progrmme}"
  }
}

# resource "azurerm_resource_group" "example" {

#   lifecycle {
#     create_before_destroy = true
#     ignore_changes = [
#       # Ignore changes to tags, e.g. because a management agent
#       # updates these based on some ruleset managed elsewhere.
#       tags,
#     ]
#     replace_triggered_by = [
#       # Replace `aws_appautoscaling_target` each time this instance of
#       # the `aws_ecs_service` is replaced.
#       aws_ecs_service.svc.id
#     ]
#     precondition {
#       condition     = data.aws_ami.example.architecture == "x86_64"
#       error_message = "The selected AMI must be for the x86_64 architecture."
#     }
#   }
# }


resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = "<your_compartment_OCID_here>"
  display_name   = "My internal VCN"
}

resource "oci_core_subnet" "dev" {
  vcn_id                      = oci_core_vcn.internal.id
  cidr_block                  = "172.16.0.0/24"
  compartment_id              = "<your_compartment_OCID_here>"
  display_name                = "Dev subnet 1"
  prohibit_public_ip_on_vnic  = true
  dns_label                   = "dev"
}

