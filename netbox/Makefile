all: delete create

namespace = netbox

delete:
	kubectl delete --namespace=$(namespace) -f Ingress.yaml
	kubectl delete --namespace=$(namespace) -f Nginx.yaml
	kubectl delete --namespace=$(namespace) -f Netbox.yaml
	kubectl delete --namespace=$(namespace) -f Postgres.yaml
	kubectl delete -f Namespace.yaml

create:
	kubectl apply -f Namespace.yaml
	kubectl apply --namespace=$(namespace) -f Postgres.yaml
	kubectl apply --namespace=$(namespace) -f Netbox.yaml
	kubectl apply --namespace=$(namespace) -f Nginx.yaml
	kubectl apply --namespace=$(namespace) -f Ingress.yaml

