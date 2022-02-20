# from https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

create_cluster:
	eksctl create cluster -f cluster.yaml

delete_cluster:
	eksctl delete cluster -f cluster.yaml

describe_cluster:
	eksctl utils describe-stacks --region=us-west-2 --cluster=mapserver

aws_identity:
	aws sts get-caller-identity

set_context:
	eksctl utils write-kubeconfig --cluster=mapserver --set-kubeconfig-context=true

enable_iam_sa_provider:
	eksctl utils associate-iam-oidc-provider --cluster=mapserver --approve

create_cluster_role:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml

create_iam_policy:
	curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json
	aws iam create-policy \
		--policy-name AWSLoadBalancerControllerIAMPolicy \
		--policy-document file://iam_policy.json

create_service_account:
	eksctl create iamserviceaccount \
      --cluster=mapserver \
      --namespace=kube-system \
      --name=aws-load-balancer-controller \
      --attach-policy-arn=arn:aws:iam::277014642641:policy/AWSLoadBalancerControllerIAMPolicy \
      --override-existing-serviceaccounts \
      --approve



deploy_application:
	kustomize build ./k8s | kubectl apply -f -


delete_application:
	kustomize build ./k8s | kubectl delete -f -

eks_charts:
	helm repo add eks https://aws.github.io/eks-charts

helm_update:
	helm repo update	

install_loadbalancer:
	helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
 			-n kube-system \
			--set clusterName=cluster-name \
 		 	--set serviceAccount.create=false \
  			--set serviceAccount.name=aws-load-balancer-controller 

verify_controller:
	kubectl get deployment -n kube-system aws-load-balancer-controller


