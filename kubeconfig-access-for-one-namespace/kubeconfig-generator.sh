#!/usr/bin/env bash

set -e

print_help() {
  echo "Usage: $(basename "$0") <service_account> <namespace>"
  echo "  <service_account>   Service Account to use for kubeconfig generation"
  echo "  <namespace>         Namespace of the service account (optional)"
}

parse_args() {
  serviceAccount=$1
  echo "Generating kubeconfig for the following service account: $serviceAccount"

  if [ $# -eq 2 ]; then
    namespace=$2
  else
    namespace=$(kubectl config view --minify -o jsonpath='{..namespace}')
    echo "No namespace specified, using currently selected namespace: $namespace"
  fi
}

wait_for_secret() {
  local secretName="$1"
  local namespace="$2"
  local maxRetries="$3"
  local retryInterval="$4"

  echo "Giving the service account token some time to be generated..."

  for i in $(seq 1 "$maxRetries"); do
    if kubectl get secret "$secretName" --namespace "$namespace" -o jsonpath='{.data.token}' >/dev/null 2>&1 &&
      kubectl get secret "$secretName" --namespace "$namespace" -o jsonpath='{.data.ca\.crt}' >/dev/null 2>&1; then
      return 0
    fi
    sleep "$retryInterval"
  done

  echo "Error: Secret $secretName is missing required keys."
  exit 1
}

get_cluster_details() {
  server="$(kubectl config view --minify -o jsonpath='{..server}')"
  echo Using the following endpoint: "$server"
  clusterName="$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')"
}

create_sa() {
  echo "Checking if the ServiceAccount exists..."
  kubectl get sa "$serviceAccount" --namespace "$namespace" >/dev/null 2>&1 || {
    echo "ServiceAccount $serviceAccount not found. Creating it..."
    kubectl create serviceaccount "$serviceAccount" --namespace "$namespace"
  }
}

get_sa_details() {
  local secretName
  local kubernetesVersion

  kubernetesVersion=$(kubectl version | grep Server | awk '{ print $3 }')

  if [[ "$kubernetesVersion" > "v1.23" ]]; then
    secretName="$serviceAccount"-sa-token

    # Create a secret for the service account
    render_secret_for_service_account "$secretName" "$namespace"

    # Wait for the secret to be created and populated with the service account token
    wait_for_secret "$secretName" "$namespace" 30 1
  else
    secretName=$(kubectl --namespace "$namespace" get serviceAccount "$serviceAccount" -o jsonpath='{.secrets[0].name}')
  fi

  ca=$(kubectl --namespace "$namespace" get secret "$secretName" -o jsonpath='{.data.ca\.crt}')
  token=$(kubectl --namespace "$namespace" get secret "$secretName" -o jsonpath='{.data.token}' | base64 --decode)
}

render_secret_for_service_account() {
  local secretName="$1"
  local namespace="$2"

  echo "Creating secret $secretName for service account $serviceAccount..."

  cat <<EOF | kubectl apply -f - >/dev/null 2>&1
apiVersion: v1
kind: Secret
metadata:
  name: "$secretName"
  namespace: "$namespace"
  annotations:
    kubernetes.io/service-account.name: "$serviceAccount"
type: kubernetes.io/service-account-token
EOF
}

render_kubeconfig() {
  echo "Rendering kubeconfig..."
  cat >"${clusterName}"-kubeconfig <<EOF
apiVersion: v1
kind: Config
clusters:
  - name: ${clusterName}
    cluster:
      certificate-authority-data: ${ca}
      server: ${server}
contexts:
  - name: ${serviceAccount}@${clusterName}
    context:
      cluster: ${clusterName}
      namespace: ${namespace}
      user: ${serviceAccount}
users:
  - name: ${serviceAccount}
    user:
      token: ${token}
current-context: ${serviceAccount}@${clusterName}
EOF
  echo "Kubeconfig generated successfully!"
}

create_cluster_role() {
  echo "Creating ClusterRole with all permissions in the namespace..."

  kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ${serviceAccount}-all-permissions
rules:
  - apiGroups: [""]
    resources: ["*"]
    verbs: ["*"]
  - apiGroups: ["apps"]
    resources: ["*"]
    verbs: ["*"]
  - apiGroups: ["batch"]
    resources: ["*"]
    verbs: ["*"]
  - apiGroups: ["extensions"]
    resources: ["*"]
    verbs: ["*"]
EOF
}

create_role_binding() {
  echo "Creating RoleBinding to bind ClusterRole to the Service Account..."

  kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${serviceAccount}-all-permissions-binding
  namespace: ${namespace}
subjects:
  - kind: ServiceAccount
    name: ${serviceAccount}
    namespace: ${namespace}
roleRef:
  kind: ClusterRole
  name: ${serviceAccount}-all-permissions
  apiGroup: rbac.authorization.k8s.io
EOF
}

main() {
  if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ $# -lt 1 ]; then
    print_help
    exit 0
  fi

  parse_args "$@"

  get_cluster_details
  create_sa
  get_sa_details
  render_kubeconfig

  # Create ClusterRole and RoleBinding
  create_cluster_role
  create_role_binding
}

main "$@"

