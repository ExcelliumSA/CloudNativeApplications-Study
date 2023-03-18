#!/bin/zsh
######################################################################
# Learn how to to create a deployment and a service
# from the command line with 'kubectl' and a complete YAML descriptor
######################################################################
# Setup
alias kubectl='minikube kubectl --'
DELTA=10
NAME="my-app-service"
function write_step(){
    echo -e "\e[93m[+] $1\e[0m"
}
function wait(){
    sleep $DELTA
}
# Actions
write_step "Cleanup..."
kubectl delete services $NAME
kubectl delete deployment my-app-deployment
write_step "Create Deployment & Service..."
kubectl apply -f deploy-descriptor.yaml
wait
write_step "Status - Pod/Deployments/Service:"
echo "[i] Pods:"
kubectl get pod -o wide -n default
echo "[i] Deployment:"
kubectl get deployment
echo "[i] Service:"
kubectl get services $NAME
wait
write_step "Access URL:"
tgt=$(minikube service --url $NAME)
echo $tgt
write_step "Test call:"
http $tgt
