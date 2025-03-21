## Kubernetes Installation with Kubespray (Docker Image)
## This guide explains how to install Kubernetes on a 3-node cluster using Kubespray with its official Docker image.

Prerequisites
```
3 Linux nodes with SSH access.

Python and Ansible installed.

Docker installed on the control node.

Public and private SSH keys configured for passwordless SSH access.
```

Inventory File Format
```

[kube_control_plane]
node1 ansible_host=192.168.6.130 ip=192.168.6.130 etcd_member_name=etcd1
node2 ansible_host=192.168.6.131 ip=192.168.6.131 etcd_member_name=etcd2
node3 ansible_host=192.168.6.132 ip=192.168.6.132 etcd_member_name=etcd3

[etcd:children]
kube_control_plane

[kube_node]
node1 ansible_host=192.168.6.130 ip=192.168.6.130
node2 ansible_host=192.168.6.131 ip=192.168.6.131
node3 ansible_host=192.168.6.132 ip=192.168.6.132

[k8s_cluster:children]
kube_control_plane
kube_node

```

Steps to Install Kubernetes

1. Clone Kubespray Repository

git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray

2. Create Inventory File

cp -rfp inventory/sample inventory/mycluster
vi inventory/mycluster/hosts.ini

Paste the inventory format provided above and modify as per your setup.

3. Run Kubespray Using Docker

docker run --rm -it \
  -v $PWD:/kubespray \
  -v ~/.ssh:/root/.ssh \
  -e ANSIBLE_CONFIG=/kubespray/ansible.cfg \
  quay.io/kubespray/kubespray:v2.23.0 \
  ansible-playbook -i /kubespray/inventory/mycluster/hosts.ini --become --become-user=root cluster.yml
