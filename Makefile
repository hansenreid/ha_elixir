init:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	minikube start
	eval $(minikube docker-env)

unset-docker:
	eval $(minikube docker-env -u)

build:
	docker build -t ha_elixir .

deploy:
	./k8s/deploy.sh

delete:
	./k8s/delete.sh

migrate:
	./k8s/migrate.sh

port-forward:
	kubectl config use-context minikube
	kubectl port-forward --namespace default deploy/ha-elixir 4000:4000 &
	kubectl port-forward --namespace default deploy/service-1 4001:4000 &
	kubectl port-forward --namespace default deploy/service-2 4002:4000 &
	kubectl port-forward --namespace default deploy/service-3 4003:4000 &

kill-port-forward:
	pkill -f "kubectl port-forward"
