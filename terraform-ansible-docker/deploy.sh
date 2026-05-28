#!/bin/bash
cd Terraform
terraform init
terraform apply -auto-approve
INSTANCE_IP=$(terraform output -raw instance_public_ip)

while ! ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -i /home/harshal/Downloads/my-key.pem ubuntu@$INSTANCE_IP exit;
 do   
  sleep 5
done
cd ..
ansible-playbook -i ansible/inventory.ini ansible/docker_deployment.yml

ssh -o StrictHostKeyChecking=no -i /home/harshal/Downloads/my-key.pem ubuntu@$INSTANCE_IP <<EOF
   
     docker run -d -p 80:80 --name portfolio-container harshal001/myportfolio:latest

EOF

