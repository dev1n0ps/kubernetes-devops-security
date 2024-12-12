#!/bin/bash

dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

mkdir -p $WORKSPACE/.trivy-cache
sudo chown -R jenkins:jenkins $WORKSPACE/.trivy-cache


docker run --rm -u $(id -u jenkins):$(id -g jenkins)  -v $WORKSPACE/.trivy-cache:/custom/cache aquasec/trivy:0.17.2 --cache-dir /custom/cache -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -u $(id -u jenkins):$(id -g jenkins)  -v $WORKSPACE/.trivy-cache:/custom/cache aquasec/trivy:0.17.2 --cache-dir /custom/cache -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

    # Trivy scan result processing
    exit_code=$?
    echo "Exit Code : $exit_code"

    # Check scan results
    if [[ "${exit_code}" == 1 ]]; then
        echo "Image scanning failed. Vulnerabilities found."
        exit 1;
    else
        echo "Image scanning passed. No CRITICAL vulnerabilities found."
    fi;

# To test in on server directly
# docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q --light --exit-code 1 --severity CRITICAL image openjdk:17-jdk-slim