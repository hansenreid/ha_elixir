#!/bin/sh
kubectl config use-context minikube

kubectl apply -f k8s/migrate.yaml

kubectl wait --for=condition=complete --timeout=30s job/migrate-db

kubectl logs job/migrate-db

kubectl delete job/migrate-db

