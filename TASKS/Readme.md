Main Scenario

    Deploy the 2048 app on Kubernetes
    1.1. Ensure your app has both Readiness and Liveness probes.
    Make your app accessible on the internet using your own domain or the zdevops.ir domain.
    Collect logs from the app in Elasticsearch.
    Monitor Kubernetes deployments and pods.
    Scale the app based on CPU usage to 5 instances.
    Create a Helm Chart for this application.
    Implement a CI/CD pipeline for this repository with Push-based and GitOps methods.
    7.1. The CI/CD pipeline must include a code quality check for each stage.
    7.2. Deploy the app using the Helm Chart.
    Deploy a new version of the 2048 app.
    8.1. Route 80% of the traffic to version 1 and 20% to the new version.
    8.2. Implement shadowing.
    Integrate Prometheus metrics and enable service discovery.
    Create a storage volume of 1GB for /assets.
    Set up backups for all assets stored in Kubernetes (PVCs).
    Create the namespaces packops and developers.
    12.1. Limit the packops namespace to 2GB of RAM and 4 CPU cores.
    12.2. Limit the developers namespace to 4GB of RAM and 8 CPU cores.
    Deploy Rancher and create a project for your app, including user creation.
    Deploy Longhorn for storage management.
    Set up a monitoring script to run every 10 minutes to check Redis functionality and push the results to Prometheus.

 Additional Tasks:

    The application must only be deployed on node3, and no other applications should be scheduled on this node.
    Create an admin kubeconfig for the user packops.
