all: clean create test

namespace = metallb system

delete:
	kubectl delete -f layer2-config.yaml
	kubectl delete -f metallb-system.yaml

create:
	kubectl apply -f metallb-system.yaml
	kubectl apply -f layer2-config.yaml

test:
  kubectl apply -f test-nginx-pod.yaml

clean:
  kubectl delete -f test-nginx-pod.yaml  
  kubectl delete -f layer2-config.yaml
	kubectl delete -f metallb-system.yaml
