## Deploying Nginx with MetalLB in Kubernetes

# Step 1: Install MetalLB

MetalLB needs to be installed in Layer 2 mode.
```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.11/config/manifests/metallb-native.yaml
```
Verify installation:
```
kubectl get pods -n metallb-system
```
You should see controller and speaker pods running.

## Step 2: Configure MetalLB

Create a configuration file metallb-config.yaml with an IP range.
```
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: my-ip-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.6.210-192.168.6.219
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: my-l2-advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - my-ip-pool
```
Apply the configuration:
```
kubectl apply -f metallb-config.yaml
```
Step 3: Deploy Nginx with LoadBalancer

Create a deployment and a service with a specific external IP.
```
#nginx-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```
```
#nginx-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
  loadBalancerIP: 192.168.6.210  # Assigning a specific IP from MetalLB's range
```
Apply the manifests:
```
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
```
Step 4: Verify the Service

Check if the service has the correct external IP:
```
kubectl get svc nginx
```
Test access via curl:
```
curl http://192.168.6.210
```
You should see the default Nginx welcome page.

✅ MetalLB is now serving Nginx with the specified IP range! 🚀

![image](https://github.com/user-attachments/assets/a13769ed-07bd-43cf-bb4d-a3089da81ee5)


