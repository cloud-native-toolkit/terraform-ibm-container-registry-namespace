#!/usr/bin/env bash

INPUT=$(tee)

BIN_DIR=$(echo "${INPUT}" | grep "bin_dir" | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')

export PATH="${BIN_DIR}:${PATH}"

REGION=$(echo "${INPUT}" | jq -r '.region // empty')
RESOURCE_GROUP=$(echo "${INPUT}" | jq -r '.resource_group // empty')
IBMCLOUD_API_KEY=$(echo "${INPUT}" | jq -r '.ibmcloud_api_key // empty')

if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBMCLOUD_API_KEY is required" >&2
  exit 1
fi

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

ibmcloud login --apikey "${IBMCLOUD_API_KEY}" -r "${REGION}" -g "${RESOURCE_GROUP}" 1> /dev/null || exit 1
ibmcloud cr region-set "${REGISTRY_REGION}" 1> /dev/null || exit 1
REGISTRY_SERVER=$(ibmcloud cr region | grep "icr.io" | sed -E "s/.*'(.*icr.io)'.*/\1/")

jq -n \
  --arg REGISTRY_REGION "${REGISTRY_REGION}" \
  --arg REGISTRY_SERVER "${REGISTRY_SERVER}" \
  '{"registry_region": $REGISTRY_REGION, "registry_server": $REGISTRY_SERVER}'
