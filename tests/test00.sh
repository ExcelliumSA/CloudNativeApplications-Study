#!/bin/zsh
######################################################################
# Learn how to to create a deployment and a service 
# from the command line with 'kubectl'.
######################################################################
# Setup
alias kubectl='minikube kubectl --'
IMAGE="kicbase/echo-server:1.0"
PORT="8080"
NAME="my-deploy"
DELTA=2
function write_step(){
    echo -e "\e[93m[+] $1\e[0m"
}
function wait(){
    sleep $DELTA
}
# Actions
write_step "Cleanup..."
kubectl delete services $NAME
wait
kubectl delete deployment $NAME
wait
write_step "Creation..."
kubectl create deployment $NAME --image=$IMAGE --replicas=2
wait
kubectl expose deployment $NAME --type=NodePort --port=$PORT
wait
write_step "Status - Pod/Deployments/Service:"
echo "[i] Pods:"
kubectl get pod -o wide -n default
echo "[i] Deployment:"
kubectl get deployment
echo "[i] Service:"
kubectl get services $NAME
write_step "Access URL:"
tgt=$(minikube service --url $NAME)
echo $tgt
write_step "Test call:"
http $tgt