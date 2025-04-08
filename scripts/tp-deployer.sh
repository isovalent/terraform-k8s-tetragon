#!/usr/bin/env bash

set -euo pipefail

# Wait for the Kubernetes API server to be reachable.
while ! kubectl get namespace > /dev/null 2>&1;
do
  sleep 10
done

# Wait for the Tetragon CRDs to be available. They should be installed by the Tetragon Operator.
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

# Deploy all provided TracingPolicies. Only apply *.yaml files.
kubectl apply $(ls "${TP_DIR}"/*.yaml | awk ' { print " -f " $1 } ')