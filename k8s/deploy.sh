#!/bin/bash

set -e
echo "Deploying Services..."
kubectl apply -f ./k8s/nginx/nginx-svc.yml
kubectl apply -f ./k8s/mariadb/mariadb-svc.yml
kubectl apply -f ./k8s/wordpress/wp-svc.yml

echo "Waiting for NGINX to get an external IP..."
external_ip=""
while [ -z $external_ip ]; do
    echo "Waiting for external IP..."
    external_ip=$(kubectl get svc nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    [ -z "$external_ip" ] && sleep 5
done

echo "NGINX external IP assigned: $external_ip"

echo "Deploying Kubernetes resources..."
kubectl apply -Rf ./k8s

echo "Updating WordPress ConfigMap with external IP..."
kubectl patch configmap wp-config --type=merge -p "{\"data\":{\"DOMAIN_NAME\":\"$external_ip\"}}"
