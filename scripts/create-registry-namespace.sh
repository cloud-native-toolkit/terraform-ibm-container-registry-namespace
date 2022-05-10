#!/usr/bin/env bash

REGION="$1"
RESOURCE_GROUP="$2"
REGISTRY_REGION="$3"
REGISTRY_NAMESPACE="$4"
UPGRADE_PLAN="$5"

if [[ -z "${REGION}" ]] || [[ -z "${RESOURCE_GROUP}" ]] || [[ -z "${REGISTRY_REGION}" ]] || [[ -z "${REGISTRY_NAMESPACE}" ]]; then
  echo "Usage: create-registry-namespace.sh REGION RESOURCE_GROUP REGISTRY_REGION REGISTRY_NAMESPACE [UPGRADE_PLAN]"
  exit 1
fi

if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBMCLOUD_API_KEY is required" >&2
  exit 1
fi

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

ibmcloud login -r "${REGION}" -g "${RESOURCE_GROUP}" 1> /dev/null || exit 1

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

if [[ "${UPGRADE_PLAN}" == "true" ]]; then
  echo "y" | ibmcloud cr plan-upgrade Standard
fi
