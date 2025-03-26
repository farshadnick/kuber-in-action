# Install helm first 
```
snap install helm --classic

```
# install Certmanager

 If you have installed the CRDs manually, instead of setting `installCRDs` or `crds.enabled` to `true` in your Helm install command, you should upgrade your CRD resources before upgrading the Helm chart:
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.16/cert-manager.crds.yaml
```
# Add the Jetstack Helm repository
```
helm repo add jetstack https://charts.jetstack.io
```
# Update your local Helm chart repository cache
```
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=false
```
# Install Rancher 
```
helm repo add rancher-latest https://releases.rancher.com/server-charts/stable

helm install rancher rancher-stable/rancher   --namespace cattle-system   --set bootstrapPassword=admin --set hostname=rancher.my.org
```
