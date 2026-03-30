module "karthk" {
  source = "../Day9-ChildModuleVPC"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "KVPC"
}