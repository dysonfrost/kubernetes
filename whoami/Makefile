all: delete create

namespace = whoami

delete:
	kubectl delete --namespace=$(namespace) -f Ingress.yaml
	kubectl delete --namespace=$(namespace) -f Service.yaml
	kubectl delete --namespace=$(namespace) -f Deployment.yaml
	kubectl delete namespace $(namespace)

create:
	kubectl create namespace $(namespace)
	kubectl apply --namespace=$(namespace) -f Deployment.yaml
	kubectl apply --namespace=$(namespace) -f Service.yaml
	kubectl apply --namespace=$(namespace) -f Ingress.yaml

