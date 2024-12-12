#!/bin/bash

#k8s-deployment.sh

# Use the IMAGE_NAME passed from Jenkins
echo "Using Image: $IMAGE_NAME"

sed -i "s#replace#${IMAGE_NAME}#g" k8s_deployment_service.yaml
kubectl -n default get deployment ${deploymentName} > /dev/null

 if [[ $? -ne 0 ]]; then
     echo "deployment ${deploymentName} doesnt exist"
     kubectl -n default apply -f k8s_deployment_service.yaml
 else
     echo "deployment ${deploymentName} exist"
     echo "image name - ${IMAGE_NAME}"
     kubectl -n default set image deploy ${deploymentName} ${containerName}=${IMAGE_NAME} --record=true
 fi

# kubectl -n default apply -f k8s_deployment_service.yaml