# 1- Install Fluent operator
```
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
export FLUENT_OPERATOR_CONTAINER_RUNTIME="containerd"
helm upgrade --install fluent-operator fluent/fluent-operator   --create-namespace   --set containerRuntime=${FLUENT_OPERATOR_CONTAINER_RUNTIME} -n log
```
# 2- Define Clusterinput and Cluster Output
```
kubectl applt ClusterInput.yml
kubectl applt ClusterOutput.yml
```
