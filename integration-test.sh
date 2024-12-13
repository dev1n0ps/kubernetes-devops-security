#!/bin/bash

#integration-test.sh

sleep 5s

PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

echo $PORT
echo $applicationURL:$PORT$applicationURI
# Construct the FULL_URL as a string
FULL_URL="${applicationURL}:${PORT}${applicationURI}"
echo "Constructed URL: $FULL_URL"

if [[ ! -z "$PORT" ]];
then

    # Perform the curl operation and capture the response and HTTP code
    response=$(curl -s "$FULL_URL")
    http_code=$(curl -s -o /dev/null -w "%{http_code}" "$FULL_URL")

    # Check and print the response
    if [[ -z "$response" ]]; then
        echo "Error: Response is empty"
        exit 1
    elif [[ "$response" == 100 ]]; then
        echo "Increment Test Passed"
    else
        echo "Increment Test Failed"
        exit 1
    fi;


    if [[ "$http_code" == 200 ]];
        then
            echo "HTTP Status Code Test Passed"
        else
            echo "HTTP Status code is not 200"
            exit 1;
    fi;

else
        echo "The Service does not have a NodePort"
        exit 1;
fi;