#!/bin/zsh
alias kubectl='minikube kubectl --'
kubectl delete deployment my-deploy my-app-deployment my-app1-deployment my-app2-deployment
kubectl delete services my-deploy my-app-service my-app1-service my-app2-service
kubectl delete namespace my-poc
kubectl delete namespace my-extra01
