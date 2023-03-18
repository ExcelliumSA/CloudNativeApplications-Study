#!/bin/zsh
######################################################################
# Deploy the POC environement using a YAML file
######################################################################
# Setup
alias kubectl='minikube kubectl --'
function write_step(){
    echo -e "\e[93m[+] $1\e[0m"
}
function write_substep(){
    echo -e "\e[96m>>>> $1\e[0m"
}
function wait(){
    sleep 15
}
function test_apps(){
    iep=$(kubectl get ingress -n my-poc | grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    echo "Ingress IP is $iep"
    url1="http://$iep/app1"
    write_substep "$url1"
    curl -sI $url1 | head -1
    url2="http://$iep/app2"
    write_substep "$url2"
    curl -sI $url2 | head -1
}
# Deployement actions
write_step "Cleanup..."
kubectl delete -f poc-accessrules.yaml
kubectl delete -f poc.yaml
kubectl delete namespace my-poc
write_step "Create POC namespace..."
kubectl create namespace my-poc
kubectl label namespace my-poc istio-injection=enabled
write_step "Create Deployment & Service for both app..."
kubectl apply -f poc.yaml
write_step "Let all pods be initialized..."
wait
write_step "Status - Pod/Deployments/Service..."
write_substep "Pods"
kubectl get pod -o wide -n my-poc
write_substep "Deployments"
kubectl get deployment -o wide -n my-poc
write_substep "Services"
kubectl get service -o wide -n my-poc
write_step "Get Ingress IP address & test access to both app before adding authentication/authorization rules..."
sleep 30
test_apps
# Add authentication and authorization actions
write_step "Add authentication/authorization rules..."
kubectl apply -f poc-accessrules.yaml
write_step "Let all policies be applied..."
wait
write_step "ReTest access to both app..."
test_apps