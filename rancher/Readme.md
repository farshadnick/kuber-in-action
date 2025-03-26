# Install helm first 
```
snap install helm --classic

```
# install Certmanager

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml


```

# Install Rancher 
```
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

helm install rancher rancher-stable/rancher   --namespace cattle-system   --set bootstrapPassword=admin --set hostname=rancher.my.org
```
