This assumes you have Terraform installed and kubectl installed. It also assumes you have Terraform Cloud Account setup (API Key already in Env) and that you already created the workspace name in the __config.tf__ file. In that workspace in Terraform Clou you will need to change the _Exectution Mode_ from _Remote_ to _Local_

This will provision an EKS Fargate Cluster with on demand Fargate Nodes in  US West 2 Oregon. In order to create it in another region you'd need to change a few things.

You will need to pass in your AWS CLI Profile name in the  _config.tf file. If you get an issue with Helm Provider you might need to export the kube config path. 

$ export KUBE_CONFIG_PATH=~/.kube/config

Then run 

$ terraform init\
$ terraform validate\
$ terraform plan\
$ terraform apply\

If you still get Helm Auth Errors, run the following command to connect to the EKS Farget Cluster via kubectl and then try to run _terraform apply_ again.\
$ aws eks update-kubeconfig --name eks-demo --region us-west-2 --profile <YOUR_PROFILE_NAME>

Check if Nodes are up

$ kubectl get nodes -o wide

If you get Status = Ready on all Worker Nodes you can apply 

$ cd k8s_apps
$ kubectl apply -f simple-php-apache/

Edit your /etc/hosts file to point DNS php-apache.devoperations.ca to your ALB IP and then try from your browser
