#!/usr/bin/env bash

REGION="$1"
REGISTRY_REGION_FILE="$2"

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

echo "Registry region (${REGION}): ${REGISTRY_REGION}"

if [[ -n "${REGISTRY_REGION_FILE}" ]]; then
  REGISTRY_REGION_FILE_PATH=$(dirname "${REGISTRY_REGION_FILE}")
  mkdir -p "${REGISTRY_REGION_FILE_PATH}"

  echo -n "${REGISTRY_REGION}" > "${REGISTRY_REGION_FILE}"
fi
