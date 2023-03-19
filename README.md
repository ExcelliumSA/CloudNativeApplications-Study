# CloudNativeApplications-Study

Contains the materials used for the blog post about [Cloud Native Applications](https://aws.amazon.com/what-is/cloud-native/).

# Blog post link

🚧 Work in progress...

# Lab

## Context

During this study, I take the opportunity to discover the following technology to apply any concepts learned:

* [Kubernetes](https://kubernetes.io/): I used [Minikube](https://minikube.sigs.k8s.io/docs/) for this.
* [Istio](https://istio.io/)

## Environment

> **Note**: A [Ubuntu 22.04.2 LTS Server](https://ubuntu.com/download/server) VM was used for the OS of the Kubernetes cluster single node.

> **Warning**: 🚨 Do not edit the file **[poc-accessrules.yaml](poc/poc-accessrules.yaml)** with VSCode because the formatter break the YAML structure!

💬 [Minikube](https://minikube.sigs.k8s.io/docs/) and [Istio](https://istio.io/) were installed using their documentation.

📑 Once the VM is ready, the following script can be used:

* [env-addtools.sh](env-addtools.sh): Add tools used by the POC.
* [env-start.sh](env-start.sh): Start the Minikute instance and POC requirements (*this script hang so open it in a dedicated shell*)
* [env-shutdown.sh](env-shutdown.sh): Stop the Minikute instance and shutdown the VM in a clean way.

📦 The lab content in stored in the [poc](poc/) folder.

📦 The image [ealen/echo-server](https://hub.docker.com/r/ealen/echo-server) was used for the application of the POC.

🧪 The [test](tests/) folder contains learning content created/tried before the creation of the POC.

🔑 The keypair (RSA 2048 bits) used for the lab (JWT token signature) is defined in the following files:

* [Private key](poc/rsa-2048-private.jwks.json).
* [Public key](poc/rsa-2048-public.jwks.json).

# Useful commands oftenly used

💻 See authentication/authorization policies in place:

```bash
kubectl exec $(kubectl get pods -l app=my-app1 -n my-poc -o jsonpath='{.items[0].metadata.name}') -n my-poc -c istio-proxy -- pilot-agent request GET config_dump
```

💻 Enable debug log

```bash
istioctl proxy-config log deployment/my-app1-deployment -n my-poc --level "rbac:debug"
```

💻 See log

```bash
kubectl logs deployment/my-app1-deployment --namespace=my-poc -c istio-proxy
```

# References

* <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>
* <https://kubernetes.io/docs/concepts/services-networking/service/>
* <https://kubernetes.io/docs/concepts/services-networking/ingress/>
* <https://istio.io/latest/docs/ops/common-problems/security-issues/#ensure-istiod-distributes-policies-to-proxies-correctly>
* <https://istio.io/latest/docs/ops/common-problems/security-issues/#ensure-proxies-enforce-policies-correctly>
* <https://istio.io/latest/docs/reference/config/security/request_authentication/>
* <https://istio.io/latest/docs/tasks/security/authorization/authz-jwt/>
* <https://istio.io/latest/docs/reference/config/security/jwt/>
* <https://stackoverflow.com/a/62417272>
* <https://istiobyexample.dev/jwt/>

# Tools

* <https://connect2id.com/products/nimbus-jose-jwt/generator>
* <https://mkjwk.org/>
