provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-02dfbd4ff395f2a1b" # Amazon Linux 2 (update if needed)
  instance_type = "t3.medium"
#   key_name      = "your-keypair"

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              yum update -y

              # Install Java (required for Jenkins)
              yum install -y java-17-amazon-corretto

              # Install Git
              yum install -y git

              # Install Terraform
              yum install -y yum-utils
              yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
              yum install -y terraform

              # Add Jenkins repo
              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

              # Install Jenkins
              yum install -y jenkins

              # Start Jenkins
              systemctl enable jenkins
              systemctl start jenkins
              EOF

  tags = {
    Name = "karthik"
  }
}