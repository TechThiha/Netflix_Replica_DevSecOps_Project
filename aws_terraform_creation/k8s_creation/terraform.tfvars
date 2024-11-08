region            = "ap-southeast-1"
security_group_id = "sg-0aebfc2f996e17354"
key_name          = "net_key"
ami_id            = "ami-047126e50991d067b"
storage           = 30
instance_type     = "t2.large"
volume_type       = "gp2"
instance_name     = "Netflix_Henry"
master_user_data  = "../modules/user_data/masterk8x.sh"
worker_user_data  = "../modules/user_data/workerk8x.sh"
environment       = "k8s"       
