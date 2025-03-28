
### 1- Create Imagepull secret with name regcred
```
kubectl create secret docker-registry regcred   --docker-server=https://hub.zdevops.ir   --docker-username=admin   --docker-password=Harbor12345
```
### 2- Create a Robobot account and make a variable in GitLab name DOCKER_PASSWORD
### 3- Create a another robot account for your helm repo on harbor in gitlab name PASSWORD_HELM 
### 3- Push Helm chart in harbor 
```
export CHART_VERSION=1.1.1
git clone https://github.com/stakater/application.git

echo Harbor12345 | helm registry login -u USERNAME --password-stdin hub.zdevops.ir
helm package --version ${CHART_VERSION} ./application
helm push application-${CHART_VERSION}.tgz oci://hub.zdevops.ir/YOUR_HELM_REPO
```

## 4- Register Docker Executor in assign it to the group
  4-1- bring up runner and then register Your Runner 
```
docker exec -it gitlab-runner-iman-gitlab-runner-1 bash
sudo gitlab-runner register --url http://192.168.6.253/ --registration-token <YOUR_TOKEN>
```
 4-2 after that change this configuration from ``/YOUR_RUNNNER_DOCKER_COMPOSE_PATH/config/config.toml``

```
privileged = true
volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
pull_policy = "if-not-present"

```
## 5- COPY KUBECONF in a variable in GitLab (as File variable) name KUBE_CONFIG
![image](https://github.com/user-attachments/assets/71366821-41ca-4a0b-b294-c04d456e9e45)

### 6- put values.yaml in root of project 

### 7- and put gitlab-ci.yml in project
```
services:
  - docker:dind
variables:
  IMAGE_ADDR: hub.zdevops.ir/packops/hello-go-kuber
  PROJECTNAME: hello-farshad
 
stages:
  - build
  - deploy
build:
  stage: build
  script:
    - echo '192.168.6.220 hub.zdevops.ir' >> /etc/hosts 
    - echo $PASSWORD | docker login hub.zdevops.ir -u robot\$packops+rb --password-stdin
    - echo $CI_COMMIT_SHORT_SHA
    - docker build . -t hub.zdevops.ir/packops/hello-go-kuber:$CI_COMMIT_SHORT_SHA
    - docker push hub.zdevops.ir/packops/hello-go-kuber:$CI_COMMIT_SHORT_SHA
  tags:
  - runner-packops

deploy-stg:
  extends: .deploy-stg

.deploy-stg:
  stage: deploy
  image:
    name: alpine/helm
    entrypoint: [""]
  variables:
    ENV: staging
  before_script:
    - echo '192.168.6.220 hub.zdevops.ir' >> /etc/hosts
    - echo $PASSWORD_HELM | helm registry login -u admin --password-stdin hub.zdevops.ir
   
  script:
    - export KUBECONFIG=$KUBE_CONFIG
    - |
      cat <<EOF >commonAnnotations.yaml
      commonAnnotations:
        staging:
          backstage.io/source-location: url:${CI_PROJECT_URL}
          backstage.io/kubernetes-namespace: ${NS_STG}
          backstage.io/kubernetes-id: $PROJECTNAME
      EOF
    
    - helm upgrade --install --atomic --wait --timeout 240s farshad-hello oci://hub.zdevops.ir/helm-char/application --version v1.1.1 -f values.yaml --set deployment.image.repository=${IMAGE_ADDR} --set deployment.image.tag=${CI_COMMIT_SHORT_SHA} --debug 
  rules:
    - if: '$CI_COMMIT_BRANCH == "main" || $CI_COMMIT_BRANCH == "k8s-plt" || $CI_COMMIT_BRANCH == "devops-change"'
      when: on_success
  tags:
    - runner-packops #>>>>> Change it to our runner tag


```
