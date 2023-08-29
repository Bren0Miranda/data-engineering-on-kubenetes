### KIND ###
make kind-cluster-create

make k8s-helm-repo-add

### Observability ###
make k8s-prometheus-grafana

### Streaming ###
make k8s-strimzi-kafka
make k8s-kafka-ui

### Storage ###
make k8s-minio


### Apps ###
make k8s-kafka-app