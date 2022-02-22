#!/bin/sh
kubectl config use-context minikube

helm install ha-elixir-postgres --set auth.postgresPassword=postgres bitnami/postgresql --wait

kubectl run ha-elixir-postgres-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:14.1.0-debian-10-r80 --env="PGPASSWORD=postgres" \
        --command -- psql --host ha-elixir-postgres-postgresql -U postgres -d postgres -p 5432 -c 'CREATE DATABASE ha_elixir_prod'

./k8s/migrate.sh

kubectl apply -f k8s/deployments.yaml
