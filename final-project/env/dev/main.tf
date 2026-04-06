//creating VPC, subnets, nat routing tables, etc
module "vpc" {
  source              = "../../modules/vpc"
  vpc-cidr            = "10.0.0.0/16"
  vpc-name            = "Dharma-VPC"
  azs                 = ["us-west-2a", "us-west-2b"]
  private-subnet-cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  public-subnet-cidr  = ["10.0.3.0/24", "10.0.4.0/24"]
}



//Sg for ec2
module "ec2-sg" {
  source = "../../modules/securitygroup"
  ingress-rule-map = {
    22 = "0.0.0.0/0"
    80 = "0.0.0.0/0"
    5000="0.0.0.0/0"
  }
  sg-vpc   = module.vpc.vpc-id
  sg-name  = "ec2-sg"
  name-tag = "SG1"
}

//sg for alb
module "alb-sg" {
  source = "../../modules/securitygroup"
  ingress-rule-map = {
    80 = "0.0.0.0/0"
    5000  = "0.0.0.0/0"
  }
  sg-vpc   = module.vpc.vpc-id
  sg-name  = "alb-sg"
  name-tag = "SG2"
}

//sg for db
module "db-sg" {
  source = "../../modules/securitygroup"
  ingress-rule-map = {
    3306 = "0.0.0.0/0"
  }
  sg-vpc   = module.vpc.vpc-id
  sg-name  = "db-sg"
  name-tag = "SG3"
}

//creating ec2 with custom sg
module "ec2" {
  source             = "../../modules/ec2"
  instance-name      = "FrontEnd"
  instance-type      = "t3.micro"
  subnet-id          = module.vpc.private-subnet-ids[0]
  sg_ids             = [module.ec2-sg.sg_id]
  name               = "FrontEnd"
  user_data = <<-EOF
  #!/bin/bash
  set -euo pipefail
  echo "Starting user data script..."
  yum install -y git
  yum install -y nginx
  systemctl enable nginx
  systemctl start nginx
  cd /tmp
  git clone https://github.com/dharmaparasa/FrontendBackend.git
  rm -rf /usr/share/nginx/html/*
  cp -r /tmp/FrontendBackend/frontend/* /usr/share/nginx/html/

  export BACKEND_DNS=${module.internal_alb.dns_name}

  cat <<EOT > /etc/nginx/conf.d/proxy.conf
  server {
      listen 80;

      location /api/ {
          proxy_pass http://$BACKEND_DNS;

          proxy_set_header Host \$host;
          proxy_set_header X-Real-IP \$remote_addr;
          proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      }
  }
  EOT


  #chown -R nginx:nginx /usr/share/nginx/html
  systemctl restart nginx
  EOF


}


module "ec2_backend" {
  source             = "../../modules/ec2"
  instance-name      = "Backend"
  instance-type      = "t3.micro"
  subnet-id          = module.vpc.private-subnet-ids[0]
  sg_ids             = [module.ec2-sg.sg_id]
  name                ="Backend"
  user_data = <<-EOF1
#!/bin/bash
set -euo pipefail

yum install -y git
yum install -y python3-pip
pip3 install virtualenv

cd /opt
git clone https://github.com/dharmaparasa/FrontendBackend.git
cd /opt/FrontendBackend/backend

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

cat <<EOF > /etc/myapp.env
DB_HOST=${module.db.db_endpoint}
DB_USER=${var.db_username}
DB_PASS=${var.db_password}
DB_NAME=demodb
EOF

cat <<EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My Python App
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/opt/FrontendBackend/backend
EnvironmentFile=/etc/myapp.env
ExecStart=/opt/FrontendBackend/backend/venv/bin/python app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp

EOF1


}
//creating alb with custom sg
module "alb" {
  source             = "../../modules/loadbalancer"
  alb-name           = "KarthikALB"
  alb-public-subnets = module.vpc.public-subnet-ids
  alb-sgs            = [module.alb-sg.sg_id]
  alb-vpc-id         = module.vpc.vpc-id
  ec2-instance-id    = module.ec2.instance_id
  target_port = 80
}
module "internal_alb" {
  source             = "../../modules/loadbalancer"
  alb-name           = "BackendLB"
  alb-public-subnets = module.vpc.private-subnet-ids
  alb-sgs            = [module.alb-sg.sg_id]
  alb-vpc-id         = module.vpc.vpc-id
  ec2-instance-id    = module.ec2_backend.instance_id
  target_port = 5000
  internal_lb = true
}

module "db" {
  source             = "../../modules/rds"
  db-sgs             = [module.db-sg.sg_id]
  db-private-subnets = module.vpc.private-subnet-ids
  db-instance-class  = "db.t4g.micro"
  db_username = var.db_username
  db_password = var.db_password
  db_name = "demodb"

}

