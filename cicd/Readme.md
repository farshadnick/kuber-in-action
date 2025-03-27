
# 1- Create Imagepull secret with name regcred
# 2- Create a Robobot account and make a variable in GitLab name DOCKER_PASSWORD
# 3- Push Helm chart in harbor 
```
export CHART_VERSION=1.1.1
git clone https://github.com/stakater/application.git

helm registry login -u USERNAME --password-stdin hub.zdevops.ir
helm package --version ${CHART_VERSION} ./application
helm push aoolication-${CHART_VERSION}.tgz oci://hub.zdevops.ir/YOUR_HELM_REPO
```

# 4- Register Docker Executor in assign it to the group
  4-1- bring up runner and then register Your Runner 
```
docker exec -it gitlab-runner-iman-gitlab-runner-1 bash
sudo gitlab-runner register --url http://192.168.6.253/ --registration-token <YOUR_TOKEN>
```
# 2- after that change this configuration from ``/YOUR_RUNNNER_DOCKER_COMPOSE_PATH/config/config.toml``

```
privileged = true
volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
pull_policy = "if-not-present"

```
5- COPY KUBECONF in a variable in GitLab (as File variable) name KUBE_CONFIG
![image](https://github.com/user-attachments/assets/71366821-41ca-4a0b-b294-c04d456e9e45)

