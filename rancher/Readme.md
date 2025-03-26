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

helm install rancher rancher-stable/rancher   --namespace cattle-system   --set bootstrapPassword=admin --set hostname=rancher.my.org --create-namespace
```

# change rancher svc to  nodeport 
```
kubectl edit svc rancher -n cattle-system
```
![image](https://github.com/user-attachments/assets/cc61498b-1d72-4ca3-96db-28ce16c9cd15)
![image](https://github.com/user-attachments/assets/96a5105e-31ad-4b9e-8e48-8fa4e62a749c)

