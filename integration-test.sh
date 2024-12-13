#!/bin/bash

#integration-test.sh

sleep 5s

PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

echo $PORT
echo $applicationURL:$PORT$applicationURI

if [[ ! -z "$PORT" ]];
then

    FULL_URL= curl --connect-timeout 10 -s $applicationURL:$PORT$applicationURI
    echo "Constructed URL: $FULL_URL"
    response=$(FULL_URL)
    http_code=$(curl -s -o /dev/null -w "%{http_code}" $applicationURL:$PORT$applicationURI)

    echo "response code : $response"
    echo "http_code : $http_code"

    if [[ "$response" == 100 ]];
        then
            echo "Increment Test Passed"
        else
            echo "Increment Test Failed"
            exit 1;
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