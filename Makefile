kind-cluster-create:
	kind create cluster --config ./kind/kind-config.yaml

kind-cluster-delete:
	kind delete cluster --name data-on-kubernetes	