#!/bin/zsh
function write_step(){
    echo -e "\e[93m[+] $1\e[0m"
}
alias kubectl='minikube kubectl --'
write_step "Start Minikube..."
minikube start
write_step "Enable Ingress addon Minikube..."
minikube addons enable ingress
write_step "Clear existing sample Deployments and Services..."
zsh cleanup.sh
write_step "Start Ingress tunnel (will keep hanging)..."
minikube tunnel
