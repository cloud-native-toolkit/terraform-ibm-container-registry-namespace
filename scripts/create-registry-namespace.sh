#!/usr/bin/env bash

RESOURCE_GROUP="$1"
REGISTRY_REGION="$2"
REGISTRY_NAMESPACE="$3"
UPGRADE_PLAN="$4"
REGISTRY_SERVER_FILE="$5"

if [[ -z "${RESOURCE_GROUP}" ]] || [[ -z "${REGISTRY_REGION}" ]] || [[ -z "${REGISTRY_NAMESPACE}" ]]; then
  echo "Usage: create-registry-namespace.sh RESOURCE_GROUP REGISTRY_REGION REGISTRY_NAMESPACE [UPGRADE_PLAN] [REGISTRY_SERVER_FILE]"
  exit 1
fi

ibmcloud cr region-set "${REGISTRY_REGION}"
echo "Checking registry namespace: ${REGISTRY_NAMESPACE}"
NS=$(ibmcloud cr namespaces | grep "${REGISTRY_NAMESPACE}" ||: )
if [[ -z "${NS}" ]]; then
    echo -e "Registry namespace ${REGISTRY_NAMESPACE} not found, creating it."
    set -e
    ibmcloud cr namespace-add "${REGISTRY_NAMESPACE}" -g "${RESOURCE_GROUP}" || exit 1
else
    echo -e "Registry namespace ${REGISTRY_NAMESPACE} found."
fi

REGISTRY_SERVER=$(ibmcloud cr region | grep "icr.io" | sed -E "s/.*'(.*icr.io)'.*/\1/")
echo "Registry server: ${REGISTRY_SERVER}"

if [[ -n "${REGISTRY_SERVER_FILE}" ]]; then
  REGISTRY_SERVER_PATH=$(dirname "${REGISTRY_SERVER_FILE}")
  mkdir -p "${REGISTRY_SERVER_PATH}"

  echo -n "${REGISTRY_SERVER}" > "${REGISTRY_SERVER_FILE}"
fi

if [[ "${UPGRADE_PLAN}" == "true" ]]; then
  echo "y" | ibmcloud cr plan-upgrade Standard
fi
