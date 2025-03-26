
# Argocd installation
```
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl edit svc -n argocd argocd-server

kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath={.data.password} | base64 -d

 kubectl create -n argocd secret docker-registry harbor-secret   --docker-username "admin"   --docker-password Harbor12345   --docker-server hub.zdevops.ir

```

#image updater 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

This tutorial covers deploying a Go application (hello-go-kuber) using ArgoCD and Helm. It also demonstrates how to configure ArgoCD Image Updater for automatic image updates.

Prerequisites
- A running Kubernetes cluster
- ArgoCD installed and configured
- Access to a private Git repository
- A container registry with the application image

# Step 1: Define the ArgoCD Application
Create an ArgoCD Application resource that deploys hello-go-kuber using Helm:
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: hello-go-kuber
  namespace: argocd
  annotations:
    argocd-image-updater.argoproj.io/image-list: harbor=hub.zdevops.ir/packops/hello-kuber
    argocd-image-updater.argoproj.io/harbor.update-strategy: newest-build
    argocd-image-updater.argoproj.io/harbor.helm.image-name: deployment.image.name
    argocd-image-updater.argoproj.io/harbor.helm.image-tag: deployment.image.tag
    argocd-image-updater.argoproj.io/harbor.git-branch: main
    argocd-image-updater.argoproj.io/harbor.pull-secret: pullsecret:argocd/harbor-secret
    argocd-image-updater.argoproj.io/harbor.write-back-method: argocd
spec:
  project: default
  sources:
  - repoURL: 'http://192.168.6.253/devops/helm-chart.git'
    path: .
    targetRevision: HEAD
    helm:
      valueFiles:
      - $values/overlays/production/values.yaml
  - repoURL: 'http://192.168.6.253/packops/hello-kuber.git'
    targetRevision: main
    ref: values
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
# Step 2: Configure Private Git Repository Access

Since the application sources are stored in private repositories, create Kubernetes secrets to authenticate with Git:
```
apiVersion: v1
kind: Secret
metadata:
  name: argocd-private-repo-packops
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: http://192.168.6.253/packops
  username: ag
  password: glpat-qbPU7skTZiBAZvHVH3ou
---
apiVersion: v1
kind: Secret
metadata:
  name: argocd-private-repo-devops
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: http://192.168.6.253/devops/helm-chart.git
  username: ag
  password: glpat-i2dqG2Fh-zJnCgHL6n41
```

# Step 3: Deploy the Application

Apply the ArgoCD Application and Secret manifests:
```
kubectl apply -f application.yaml
kubectl apply -f secrets.yaml
```
Verify the deployment:
```
kubectl get applications -n argocd
```
# Step 4: Enable ArgoCD Image Updater

ArgoCD Image Updater automatically updates the application when a new image version is available. Ensure ArgoCD Image Updater is running and configured correctly:
```
kubectl get pods -n argocd | grep image-updater
```
