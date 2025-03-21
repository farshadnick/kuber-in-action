# Taint and Toleration for BI Team Application

## Step 1: Taint Node 3

To prevent any application from being scheduled on Node 3, taint the node as follows:

```
kubectl taint nodes node-3 key=bi-team:NoSchedule
```

Step 2: BI Team Application Deployment with Toleration

Add a toleration to the BI team application’s deployment so that it can still be scheduled on Node 3:


```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bi-team-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bi-team-app
  template:
    metadata:
      labels:
        app: bi-team-app
    spec:
      tolerations:
        - key: "bi-team"
          operator: "Equal"
          value: "NoSchedule"
          effect: "NoSchedule"
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: kubernetes.io/hostname
                    operator: In
                    values:
                      - node-3
      containers:
        - name: bi-team-app
          image: bi-team-app-image

```
