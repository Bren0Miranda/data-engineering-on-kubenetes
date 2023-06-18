### Kind ###
kind-cluster-create:
	@kind create cluster --config ./kind/kind-config.yaml --name data-on-k8s

kind-cluster-delete:
	@kind delete cluster --name data-on-k8s


### K8S - Namespace ###
k8s-namespace-create:
	@kubectl create namespace monitoring
	@kubectl create namespace argocd

	@kubectl create namespace strimzi-kafka
	@kubectl create namespace kafka-ui
	@kubectl create namespace kafka-app


### Helm ###
k8s-helm-repo-add:
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo add argo https://argoproj.github.io/argo-helm

	@helm repo add strimzi http://strimzi.io/charts
	@helm repo add kafka-ui https://provectus.github.io/kafka-ui

	@helm repo update


### Argo CD ###
k8s-argocd:
	@helm upgrade --install argocd argo/argo-cd --version 5.36.1 --namespace argocd


### Prometheus - Grafana ###
k8s-prometheus-grafana:
	@helm upgrade --install prometheus-operator prometheus-community/kube-prometheus-stack --values k8s/helm-charts/prometheus/values.yaml --version 46.8.0 --namespace monitoring 


### Strimzi - Kafka ###
k8s-strimzi-kafka:	
	@helm upgrade --install strimzi-kafka strimzi/strimzi-kafka-operator --version 0.35.1 --namespace strimzi-kafka
	@kubectl apply -f k8s/manifests/strimzi-kafka/kafka-ephemeral.yaml --namespace strimzi-kafka
	@kubectl apply -f k8s/manifests/strimzi-kafka/kafka-topic.yaml --namespace strimzi-kafka

k8s-kafka-ui:
	@helm upgrade --install kafka-ui kafka-ui/kafka-ui --values k8s/helm-charts/kafka-ui/values.yaml --version 0.7.0 --namespace kafka-ui 


### Apps ###
k8s-kafka-app:
	@kubectl apply -f k8s/manifests/kafka-app/kafka-producer.yaml
	@kubectl apply -f k8s/manifests/kafka-app/kafka-consumer.yaml
