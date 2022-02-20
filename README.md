## from here:
https://github.com/RobinNagpal/kubernetes-tutorials/tree/master/06_tools

https://www.youtube.com/watch?v=S8U7A-eGdOs

## New References
https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html

## Old References
https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/
https://aws.amazon.com/blogs/containers/using-alb-ingress-controller-with-amazon-eks-on-fargate/

# verify credentials on aws

make aws_identity
aws iam list-users

# create cluster

make create_cluster

# connect to cluster

make set_context
make enable_iam_sa_provider

# describe cluster
make describe_cluster

# set up role, policy and service account for loadbalancer
make enable_iam_sa_provider
make create_cluster_role
make create_iam_policy
make create_service_account



# install loadbalancer
make eks_charts
make helm_update 

make install_loadbalancer
make verify_controller

kubectl expose deployment nginx-deployment  --type=ClusterIP  --name=nginx-service-cluster-ip



