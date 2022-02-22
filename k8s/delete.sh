#!/bin/sh
kubectl config use-context minikube

kubectl delete deploy/ha-elixir
kubectl delete deploy/service-1
kubectl delete deploy/service-2
kubectl delete deploy/service-3

helm delete ha-elixir-postgres
kubectl delete pvc data-ha-elixir-postgres-postgresql-0

