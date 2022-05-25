#!/usr/bin/env bash

set -euxo pipefail

ARGOCD_DEPLOY_TIMEOUT=120s
ARGOCD_APPS_SYNC_TIMEOUT=720

CLOUD_GIT_REF=${CLOUD_GIT_REF:-HEAD}
IMG_TAG=${IMG_TAG:-latest}
ENV_NAME=${ENV_NAME:-dev}


deploy() {
    if ! command -v argocd-vault-plugin &> /dev/null; then
      echo "the argocd-vault-plugin plugin is required to deploy, download binary from https://github.com/argoproj-labs/argocd-vault-plugin/releases"
      exit 1
    fi

    echo "--- Deploying ArgoCD"
    helm dependency build argocd/
    helm upgrade --install --reset-values --namespace=argocd --create-namespace -f ${VALUES_FILE} argo-cd argocd/

    echo "--- Applying argocd-bootstrap"
    make --no-print-directory -C argocd-bootstrap generate | kubectl apply -n argocd -f -

    echo "--- Waiting for ArgoCD Server to be ready"
    kubectl wait pods -n argocd --for=condition=Ready --selector=app.kubernetes.io/name=argocd-server --timeout=${ARGOCD_DEPLOY_TIMEOUT}
    kubectl wait pods -n argocd --for=condition=Ready --selector=app.kubernetes.io/name=argocd-repo-server --timeout=${ARGOCD_DEPLOY_TIMEOUT}
}

wait_apps_synced() {
  start=$(date +%s)
  apps_synced_cycles=0
  required_apps_synced_cycles=3

  while true
  do
    apps_synced=true
    apps=$(kubectl get apps -n argocd -o json | jq -r ".items[] | [ .metadata.name, .status.health.status, .status.sync.status ] | @csv" | tr -d \")
    while IFS=",", read -r app_name app_health_status app_sync_status
    do
      if [[ $app_health_status != "Healthy" || $app_sync_status != "Synced" ]]; then
          echo "$app_name: [Health: ${app_health_status:-N/A}, Sync: ${app_sync_status:-N/A}]"
          apps_synced=false
      fi
    done < <(echo $apps | tr ' ' '\n')

    if [[ $apps_synced = true ]]
    then
      ((apps_synced_cycles++))
      if [[ $apps_synced_cycles -ge $required_apps_synced_cycles ]]
      then
        echo "All Applications are Healthy and Synced!!!"
        return
      fi
      echo "All Applications are Healthy and Synced [cycle: $apps_synced_cycles/$required_apps_synced_cycles]"
    else
      apps_synced_cycles=0
    fi

    [[ $(date +%s) -ge $(($start + ${ARGOCD_APPS_SYNC_TIMEOUT})) ]] && echo "Timeout waiting for applications to be Synced!" && exit 1

    echo "Retrying in 2 seconds..."
    sleep 2
  done
}

# This allows us to call functions as parameters of this bash script
# Run function based on arguments
if declare -f "${1}__$2" >/dev/null 2>&1; then
  func="${1}__$2"
  shift; shift    # pop $1 and $2 off the argument list
  "$func" "$@"    # invoke our named function w/ all remaining arguments
elif declare -f "$1" >/dev/null 2>&1; then
   # invoke that function, passing arguments through
  "$@" # same as "$1" "$2" "$3" ... for full argument list
elif declare -f `sed 's/-/_/g' <<< $1` >/dev/null 2>&1; then
  func=`sed 's/-/_/g' <<< $1`
  shift
  "$func" "$@"
else
  echo "Neither function '$1' nor subcommand '${1}__$2' recognized" >&2
  exit 1
fi
