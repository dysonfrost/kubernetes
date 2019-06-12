# WHOAMI
Tiny Go webserver that prints os information and HTTP request to output


## Config files related to whoami for 5ESGI-PA

- whoami-manifest.yaml

This manifest allows us to expose a webserver using a `whoami` service from the image `containous/whoami`

To install Whoami, simply apply the manifest:

```sh
kubectl apply -f https://raw.githubusercontent.com/dysonfrost/kubernetes/master/whoami/whoami-manifest.yaml
```

To verify the deployment of whoami, please execute the following command on the `manager` virtual machine:

```sh
kubectl get pods -o wide --sort-by="{.spec.nodeName}"
```

- Expected output:
```sh
NAME                                READY   STATUS    RESTARTS   AGE    IP           NODE             NOMINATED NODE   READINESS GATES
whoami-6d75494548-n56x8             1/1     Running   0          24m    10.1.1.22    juju-ea0acb-11   <none>           <none>
whoami-6d75494548-2cbzf             1/1     Running   0          24m    10.1.22.24   juju-ea0acb-12   <none>           <none>
whoami-6d75494548-xqmw6             1/1     Running   0          24m    10.1.91.22   juju-ea0acb-13   <none>           <none>

```

The goal of this container is to put in evidence that everytime you make a `HTTP GET request`, the container is displaying different informations because multiple replicas are set across the nodes.

- Expected Webpage display:

```
Hostname: whoami-6d75494548-<variable>
IP: 127.0.0.1
IP: <Dynamic Cluster-IP>
GET / HTTP/1.1
Host: <External-IP>
...
```


