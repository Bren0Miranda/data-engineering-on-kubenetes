############
### KIND ###
############
kind-cluster-create:
	@kind create cluster --config ./kind/kind-config.yaml --name data-on-k8s

kind-cluster-delete:
	@kind delete cluster --name data-on-k8s


###############
### Argo CD ###
###############
k8s-argocd:
	@helm repo add argo https://argoproj.github.io/argo-helm

	@helm upgrade --install argocd argo/argo-cd --version 5.36.1 --namespace argocd --create-namespace


##################
### Monitoring ###
##################
k8s-prometheus-grafana:
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

	@helm upgrade --install prometheus-operator prometheus-community/kube-prometheus-stack --values k8s/helm-charts/prometheus/values.yaml --version 46.8.0 --namespace monitoring --create-namespace


#################
### Streaming ###
#################
k8s-strimzi-kafka:	
	@helm repo add strimzi http://strimzi.io/charts

	@helm upgrade --install strimzi-kafka strimzi/strimzi-kafka-operator --version 0.35.1 --namespace strimzi-kafka --create-namespace

	@kubectl apply -f k8s/manifests/strimzi-kafka/kafka-ephemeral.yaml --namespace strimzi-kafka
	@kubectl apply -f k8s/manifests/strimzi-kafka/kafka-topic.yaml --namespace strimzi-kafka

k8s-kafka-ui:
	@helm repo add kafka-ui https://provectus.github.io/kafka-ui

	@helm upgrade --install kafka-ui kafka-ui/kafka-ui --values k8s/helm-charts/kafka-ui/values.yaml --version 0.7.0 --namespace kafka-ui --create-namespace


###############
### Storage ###
###############
k8s-minio:
	@helm repo add bitnami https://charts.bitnami.com/bitnami

	@helm upgrade --install minio bitnami/minio --values k8s\helm-charts\minio\values.yaml --version 11.10.20 --namespace minio --create-namespace


############
### Apps ###
############
k8s-kafka-app:
	@kubectl apply -f k8s/manifests/kafka-app/kafka-producer.yaml
	@kubectl apply -f k8s/manifests/kafka-app/kafka-consumer.yaml
