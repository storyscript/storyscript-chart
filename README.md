## Storyscript

Instructions for local setup:

1. Install [minikube](https://github.com/kubernetes/minikube) and [helm](https://github.com/helm/helm).
2. Enable the `ingress` and `ingress-dns` addons, and [add the minikube ip as a DNS server](https://github.com/kubernetes/minikube/tree/master/deploy/addons/ingress-dns#add-the-minikube-ip-as-a-dns-server) for the `.test` TLD.
```
$ minikube addons enable ingress ingress-dns
$ # add the minikube IP as a DNS server for the .test TLD (follow ingress-dns instructions)
```
3. Install the helm chart in the `asyncy-system` namespace.
```
$ kubectl create namespace asyncy-system
$ helm install storyscript . --namespace asyncy-system --set hello-world.enabled=true
```
4. Curl the hello-world app! 🚀
```
$ curl hello-world.local.storyscript.test
```
