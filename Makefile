### Kind ###
kind-cluster-create:
	@kind create cluster --config ./kind/kind-config.yaml

kind-cluster-delete:
	@kind delete cluster --name data-on-k8s


### K8S - Namespace ###
k8s-namespace-create:
	@kubectl create namespace strimzi-kafka
	@kubectl create namespace kafka-ui
	@kubectl create namespace kafka-app

### Helm ###
k8s-helm-repo-add:
	@helm repo add kafka-ui https://provectus.github.io/kafka-ui

k8s-helm-install:
	@helm install strimzi-kafka strimzi/strimzi-kafka-operator --namespace strimzi-kafka


### Strimzi - Kafka ###
k8s-strimzi-kafka:	
	@kubectl apply -f k8s/strimzi-kafka/kafka-ephemeral.yaml
	@kubectl apply -f k8s/strimzi-kafka/kafka-topic.yaml

k8s-kafka-ui:
	@helm install kafka-ui kafka-ui/kafka-ui --set envs.config.KAFKA_CLUSTERS_0_NAME=data-on-k8s --set envs.config.KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=strimzi-kafka-bootstrap.strimzi-kafka.svc.cluster.local:9092 --namespace kafka-ui


### Kafka - App##
k8s-kafka-app:
	@kubectl apply -f k8s/kafka-app/kafka-producer.yaml
	@kubectl apply -f k8s/kafka-app/kafka-consumer.yaml