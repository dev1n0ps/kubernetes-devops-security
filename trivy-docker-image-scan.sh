#!/bin/bash

dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

sudo chown -R jenkins:jenkins $WORKSPACE
sudo chmod -R 755 $WORKSPACE

docker run --rm -u $(id -u jenkins):$(id -g jenkins)  -v $WORKSPACE/.cache:/root/.cache aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -u $(id -u jenkins):$(id -g jenkins)  -v $WORKSPACE/.cache:/root/.cache aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

    # Trivy scan result processing
    exit_code=$?
    echo "Exit Code : $exit_code"

    # Check scan results
    if [[ "${exit_code}" == 1 ]]; then
        echo "Image scanning failed. Vulnerabilities found"
        exit 1;
    else
        echo "Image scanning passed. No CRITICAL vulnerabilities found"
    fi;