## Main Scenarios
----------------------

1. **Deploy the Codename app on Kubernetes**  
   1.1. Ensure your app has both Readiness and Liveness probes.  

2. **Make your app accessible on the internet**  
   - Use your own domain or the `zdevops.ir` domain.  

3. **Collect logs from the app in Elasticsearch.**

4. **Monitor Kubernetes deployments and pods.**

5. **Scale the app based on CPU usage**  
   - Scale to 5 instances.  

6. **Create a Helm Chart for this application.**

7. **Implement a CI/CD pipeline for this repository**  
   - Use Push-based and GitOps methods.  
   7.1. The CI/CD pipeline must include a code quality check for each stage.  
   7.2. Deploy the app using the Helm Chart.  

8. **Deploy a new version of the Codename app**  
   8.1. Route 80% of the traffic to version 1 and 20% to the new version.  
   8.2. Implement shadowing.  

9. **Integrate Prometheus metrics and enable service discovery.**

10. **Create a storage volume of 1GB for `/assets`.**

11. **Set up backups for all assets stored in Kubernetes (PVCs).**

12. **Create the namespaces `packops` and `developers`.**  
   12.1. Limit the `packops` namespace to 2GB of RAM and 4 CPU cores.  
   12.2. Limit the `developers` namespace to 4GB of RAM and 8 CPU cores.  

13. **Deploy Rancher**  
   - Create a project for your app, including user creation.  

14. **Deploy Longhorn for storage management.**

15. **Set up a monitoring script**  
   - Runs every 10 minutes to check Redis functionality and push the results to Prometheus.  
16. **Bring up a Loadbalancer**  
   - Your Codename Service must be able with single ip 
## Additional Scenarios
------------------------

1. The application must only be deployed on `node3`, and no other applications should be scheduled on this node.
2. Create an admin kubeconfig for the user `packops`.
3. Run Kubescape in order to Run Security Audit Check
4. Enable Kubernetes Audit Log
5. monitor pod crash with kwatch
6. 
