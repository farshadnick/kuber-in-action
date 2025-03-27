# 1- bring up runner and then register Your Runner 

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
