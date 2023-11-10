#!/bin/bash

# Define variables
NAMESPACE=${NAMESPACE}
POD=${POD_NAME}
CONTAINER=${CONTAINER_NAME}
LOG_FILE=${LOG_FILE_PATH}

# Get logs from container
kubectl logs -n $NAMESPACE $POD $CONTAINER > $LOG_FILE

# Search logs for configuration errors
grep -i "configuration" $LOG_FILE

# Additional commands for reviewing Istio configuration files
# kubectl get configmap istio -n istio-system -o yaml
# kubectl get virtualservices -n ${NAMESPACE} -o yaml