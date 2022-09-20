locals {

  owner   = "julien" # lower case only
  my_cidr =  "192.168.0.0/20" # (x.x.x.x/xx)
  my_ip   = "${jsondecode(data.curl.public_ip.response)["ip"]}/32"
  context = {

    owner  = local.owner
    env    = "dojo"
    region = "eu-central-1"

    tags = {
      Name = "${local.owner}-dojo"
    }

    vpc = {
      availability_zone = ["eu-central-1a", "eu-central-1b"]
      cidr              = local.my_cidr
    }
  }

  eks = {
  	cluster = {
  	name    = local.owner
  	version = "1.21"
  	}
  	node = {
  		name           = "eks_node"
  		capacity_type  = "SPOT"
 		 instance_types = ["t3a.xlarge", "c5a.xlarge", "t3.xlarge", "c5.xlarge", "c6i.xlarge", "m5a.xlarge"]
  		scaling_config = {
  			min_size     = 1
  			max_size     = 10
  			desired_size = 1
  		}
 	}
  }

  #ecr_name = "${local.owner}/demo-k8s"
}

data "curl" "public_ip" {
  http_method = "GET"
  uri         = "https://ipinfo.io"
}
