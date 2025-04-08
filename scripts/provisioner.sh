#!/usr/bin/env bash

set -euo pipefail

# Wait for the Kubernetes API server to be reachable.
while ! kubectl get namespace > /dev/null 2>&1;
do
  sleep 10
done

# Create the target namespace if it does not exist.
kubectl create namespace "${TETRAGON_NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# Run any pre-install script we may have been provided with.
if [[ "${PRE_TETRAGON_INSTALL_SCRIPT}" != "" ]];
then
  base64 --decode <<< "${PRE_TETRAGON_INSTALL_SCRIPT}" | bash
fi

# Get the latest information about charts from the respective chart repositories.
helm repo update

# Substitute environment variables into the Tetragon Helm values file.
envsubst < "${TETRAGON_HELM_VALUES_FILE}" > tmp1 

if [[ "${TETRAGON_HELM_VALUES_OVERRIDE_FILE}" != "" ]];
then
  # Substitute environment variables into the Tetragon Helm values override file.
  envsubst < "${TETRAGON_HELM_VALUES_OVERRIDE_FILE}" | \
  helm upgrade --install "${TETRAGON_HELM_RELEASE_NAME}" "${TETRAGON_HELM_CHART}" \
  --version "${TETRAGON_HELM_VERSION}" -n "${TETRAGON_NAMESPACE}" -f tmp1 -f /dev/stdin ${TETRAGON_HELM_EXTRA_ARGS}
  rm -f tmp1
else
  envsubst < tmp1 | \
  helm upgrade --install "${TETRAGON_HELM_RELEASE_NAME}" "${TETRAGON_HELM_CHART}" \
  --version "${TETRAGON_HELM_VERSION}" -n "${TETRAGON_NAMESPACE}" -f /dev/stdin ${TETRAGON_HELM_EXTRA_ARGS}
  rm -f tmp1
fi

# If asked to, wait for the Tetragon CRDs to be available before proceeding.
# By default they are installed by the Tetragon operator, but it is now possible to install them out-of-band.
if [[ "${WAIT_FOR_TETRAGON_CRDS}" == "true" ]];
then
  TETRAGON_CRD_AVAILABILITY_COUNT=1
  set +e
  until kubectl get crd tracingpolicies.cilium.io
  do
    if [[ ${TETRAGON_CRD_AVAILABILITY_COUNT} -gt ${WAIT_FOR_TETRAGON_CRDS_TIMEOUT} ]];
    then
      echo "Tetragon CRDs are not available. Check Tetragon installation."
      exit 1
    else
      TETRAGON_CRD_AVAILABILITY_COUNT=$((TETRAGON_CRD_AVAILABILITY_COUNT+1))
      sleep 1
    fi
  done
  set -e
fi

# Run any post-install script we may have been provided with.
if [[ "${POST_TETRAGON_INSTALL_SCRIPT}" != "" ]];
then
  base64 --decode <<< "${POST_TETRAGON_INSTALL_SCRIPT}" | bash
fi
