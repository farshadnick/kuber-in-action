# Push Chart to private repo 
```
export CHART_VERSION=1.1
helm registry login -u USERNAME --password-stdin hub.zdevops.ir
helm package --version ${CHART_VERSION} ./helm-chart
helm push helm-chart-${CHART_VERSION}.tgz oci://hub.zdevops.ir/helm

```
