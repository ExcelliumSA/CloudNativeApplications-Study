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
    iep=$(kubectl get ingress -n my-extra01 | grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    echo "Ingress IP is $iep"
    url1="http://$iep/app1"
    write_substep "Perform a HTTP HEAD call to $url1"	
    curl -sI $url1 | head -1
}
# Deployement actions
write_step "Cleanup..."
kubectl delete -f extra01-accessrules.yaml
kubectl delete -f extra01.yaml
kubectl delete namespace my-extra01
write_step "Create Extra01 namespace..."
kubectl create namespace my-extra01
kubectl label namespace my-extra01 istio-injection=enabled
write_step "Create Deployment & Service for both app..."
kubectl apply -f extra01.yaml
write_step "Let all pods be initialized..."
wait
write_step "Status - Pod/Deployments/Service..."
write_substep "Pods"
kubectl get pod -o wide -n my-extra01
write_substep "Deployments"
kubectl get deployment -o wide -n my-extra01
write_substep "Services"
kubectl get service -o wide -n my-extra01
write_step "Get Ingress IP address & test access to app before adding any authentication/authorization rules..."
sleep 60
test_apps
# Add authentication and authorization actions
write_step "Add an authorization rule only allowing HTTP GET and HTTP POST methods..."
kubectl apply -f extra01-accessrules.yaml
write_step "Let all policies be applied..."
wait
write_step "ReTest access to apps..."
test_apps