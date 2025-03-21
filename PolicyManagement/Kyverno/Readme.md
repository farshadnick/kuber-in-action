Policy management in Kubernetes means setting rules to control how resources are used, who can access them, and how workloads behave. This helps improve security, compliance, and stability in a cluster.
Why is Policy Management important?

    Security: Prevents unauthorized access and enforces best practices.
    Compliance: Ensures the system follows company and legal rules.
    Stability: Avoids resource misuse and keeps the cluster healthy.

Tools like Kyverno and OPA Gatekeeper help enforce policies automatically.

Let’s Get started
What is the scenario ?

We want every Pod to have an app label. If not, Kyverno should block it.
1- First Step : Install Keyverno

You can install it via manifest or helm

helm installation :
```
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace
```
Manifest installation :
```
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.11.1/install.yaml
```
1–1 Install Keyverno CLI

Linux :
```
curl -LO https://github.com/kyverno/kyverno/releases/download/v1.12.0/kyverno-cli_v1.12.0_linux_x86_64.tar.gz
tar -xvf kyverno-cli_v1.12.0_linux_x86_64.tar.gz
sudo cp kyverno /usr/local/bin/
```
Mac :
```
brew install kyverno
```
arch Linux
```
yay -S kyverno-git
```
2- Define a Policy

The validationFailureAction field in Kyverno determines how the policy behaves when a resource violates the defined rules. There are two main modes:

We want every Pod to have an app label. If not, Kyverno should block it.
```
#policy.yml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-app-label
spec:
  validationFailureAction: Enforce
  rules:
  - name: check-for-app-label
    match:
      resources:
        kinds:
        - Pod
    validate:
      message: "All Pods must have the 'app' label."
      pattern:
        metadata:
          labels:
            app: "?*"
```
```
kubectl apply -f policy.yml
```
validation Failure Action :

Audit (default): Testing new policies, monitoring violations, gradual enforcement.

Enforce : Strict security requirements, compliance enforcement, critical policies.
2- Create a pod without label
```
#pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
```
```
kubectl apply -f pod.yml
```
the result would be something like that
3- Verifying Your Policy

we can test the policy by :
```
kyverno apply policy.yml --resource pod.yml 
```
    policy.yml → Your Kyverno policy (e.g., enforcing labels).
    pod.yml → Your Kubernetes resource (e.g., a Pod you want to test).
