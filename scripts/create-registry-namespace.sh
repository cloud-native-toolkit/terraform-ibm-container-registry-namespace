#!/usr/bin/env bash

RESOURCE_GROUP="$1"
REGION="$2"
UPGRADE_PLAN="$3"
REGISTRY_URL_FILE="$4"

if [[ -z "${RESOURCE_GROUP}" ]] || [[ -z "${REGION}" ]]; then
  echo "Usage: create-registry-namespace.sh RESOURCE_GROUP REGION [UPGRADE_PLAN] [REGISTRY_URL_FILE]"
  exit 1
fi

# The name of a registry namespace cannot contain uppercase characters
# Lowercase the resource group name, just in case...
REGISTRY_NAMESPACE=$(echo "$RESOURCE_GROUP" | tr '[:upper:]' '[:lower:]')

if [[ "${REGION}" =~ "us-" ]]; then
  REGISTRY_REGION="us-south"
elif [[ "${REGION}" == "eu-gb" ]]; then
  REGISTRY_REGION="uk-south"
elif [[ "${REGION}" =~ "eu-" ]]; then
  REGISTRY_REGION="eu-central"
elif [[ "${REGION}" =~ "jp-" ]]; then
  REGISTRY_REGION="ap-north"
elif [[ "${REGION}" =~ "ap-" ]]; then
  REGISTRY_REGION="ap-south"
else
  REGISTRY_REGION="${REGION}"
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

REGISTRY_URL=$(ibmcloud cr region | grep "icr.io" | sed -E "s/.*'(.*icr.io)'.*/\1/")
echo "Registry url: ${REGISTRY_URL}"

if [[ -n "${REGISTRY_URL_FILE}" ]]; then
  REGISTRY_URL_PATH=$(dirname "${REGISTRY_URL_FILE}")
  mkdir -p "${REGISTRY_URL_PATH}"

  echo -n "${REGISTRY_URL}" > "${REGISTRY_URL_FILE}"
fi

if [[ "${UPGRADE_PLAN}" == "true" ]]; then
  echo "y" | ibmcloud cr plan-upgrade Standard
fi
