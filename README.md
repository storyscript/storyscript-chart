## Storyscript

Instructions:

1. Install [minikube](https://github.com/kubernetes/minikube) and [helm](https://github.com/helm/helm).
2. Enable the `ingress` and `ingress-dns` addons, and [add the minikube ip as a DNS server](https://github.com/kubernetes/minikube/tree/master/deploy/addons/ingress-dns#add-the-minikube-ip-as-a-dns-server) for the `.test` TLD.  
```
$ minikube addons enable ingress ingress-dns
$ # add the minikube IP as a DNS server for the .test TLD (follow ingress-dns instructions)
```
3. Set appropriate values and install the helm chart.
```
$ cat << EOF > values.minikube.yaml
domain: storyscript.test

hello-world:
  enabled: true

auth:
  github:
    # GitHub app oauth credentials, callback URL set to:
    #  http://auth.{{ .Values.domain }}/callback
    client_id: *****
    client_secret: *****
EOF

$ helm install storyscript . -f values.minikube.yaml
```
4. Curl the hello-world app! 🚀
```
$ curl hello-world.storyscript.test
```
