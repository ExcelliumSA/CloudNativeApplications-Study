#!/bin/zsh
function write_step(){
    echo -e "\e[93m[+] $1\e[0m"
}
write_step "Clear existing sample Deployments and Services..."
zsh cleanup.sh
write_step "Stop Minikube..."
minikube stop
write_step "Wait 10 sec to let Minikube shutdown cleanly..."
sleep 10
write_step "Shutdown VM..."
sudo shutdown -h now
