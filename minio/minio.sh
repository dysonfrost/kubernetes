#!/bin/bash

# MY_SECRET must be minimum 8 or more characters long
MY_USER=''
MY_SECRET=''
MINIO_DEPLOY=$(kubectl get deployments | grep "minio-deployment " | wc -l)
MINIO_SVC=$(kubectl get services | grep "minio-service " | wc -l)

# Prompt User and Secret if empty + Secret restrictions
if [ -z "$MY_USER" ] || [ -z "$MY_SECRET" ]
then
    read -r -p "Minio Username: " MY_USER
    while true; do
        read -r -s -p "Minio Password (at least 8 characters long): " MY_SECRET
        echo
        read -r -s -p "Minio Password (again): " MY_SECRET2
        echo
        [ "$MY_SECRET" = "$MY_SECRET2" -a ${#MY_SECRET} -ge 8 ] && break ||
        echo "Try again"
    done
fi

# Encode User & Secret to Base64
MINIO_USER=$(echo -n $MY_USER | base64)
MINIO_SECRET=$(echo -n $MY_SECRET | base64)

# Check if a deployment of minio already exists
if [ "$MINIO_DEPLOY" -eq 1 ]
then
    kubectl delete -f minio-deployment.yaml
fi

# Substitute MINIO_ACCESS_KEY & MINIO_SECRET_KEY in minio-secret.yml
sed -i "s/accesskey.*/accesskey: $MINIO_USER/g" minio-secret.yaml
sed -i "s/secretkey.*/secretkey: $MINIO_SECRET/g" minio-secret.yaml

# Apply secret & (re)deploy minio
kubectl apply -f minio-secret.yaml
kubectl apply -f minio-deployment.yaml

# Check if a service of minio already exists
if [ "$MINIO_SVC" -eq 0 ]
then
    kubectl apply -f minio-service.yaml
fi

# Cleanup
sed -i "0,/MY_USER=/ s/MY_USER=.*/MY_USER=''/" minio.sh
sed -i "0,/MY_SECRET=/ s/MY_SECRET=.*/MY_SECRET=''/" minio.sh
