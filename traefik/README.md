# TRAEFIK
Traefik is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. 

Traefik is configured by rules that are used to connect “Frontends” with “Backends”. In terms of Traefik  **“Frontend”** is a public end point at some domain name like `api.mydomain`. On the other hand **“Backend”** is our deployed web service container. For example,  we can set a rule in Traefik that for `Host:api.mydomain` traffic should be routed to our api service container.

*For more informations, please visit [Traefik official website](https://docs.traefik.io)*

## Prerequisites

Traefik will be used as an Ingress Controller behind MetalLB on a Bare Metal Kubernetes Cluster.  
***MetalLB must be installed and configured*** as described in this [metallb short overview](https://github.com/dysonfrost/kubernetes/tree/master/metallb).

A generated password *(note SHA1 didn’t work for me i.e. -nbs)*, run the below (md5 hash):

```shell
htpasswd -nbm admin password1234
admin:$apr1$ZywpxeoS$6U80kYPG116slxBceEsVz0
```

## Config files related to traefik for 5ESGI-PA

- traefik-rbac.yaml

This Role Based Access Control configuration *(Kubernetes 1.6+ only)*  will take advantage of the Kubernetes API using `ClusterRole` and `ClusterRoleBinding` resources inside a dedicated namespace for traefik.

- traefik-manifest.yaml

Let's take a look at the manifest. It's divided into 7 distinct blocks:

1) Creation of a `Namespace` for traefik

    - *To separate traefik resources from the rest of the kubernetes cluster resources.*

2) Creation of a `ServiceAccount`  

    - *A service account to provide an identity for processes that run in a traefik pod.*

3) Creation of a `ConfigMap`

    - *To store and manage the configuration of traefik.*

4) Creation of a `DaemonSet`

    - *To make sure that all nodes (or some, depending on the selector) are running a copy of traefik*

5) Creation of a Traefik Ingress `Service` 

    - *A service to manage the internal traffic of the cluster, exposed as a `NodePort` on a Cluster-IP.*

6) Creation of a Traefik User Interface `Service`

    - *A service to manage Traefik from a dashboard exposed as a `LoadBalancer` on an External-IP.*

7) Creation of a Traefik Dashboard `Ingress`

    - *To expose HTTP and HTTPS routes from outside the cluster to services within the cluster with the help of Traefik.*

## How to install Traefik

Please connect to the `manager` virtual machine and apply this configuration:

`kubectl apply -f https://raw.githubusercontent.com/dysonfrost/kubernetes/master/traefik/traefik-rbac.yaml`

Make sure the RBAC resources have been properly applied

`kubectl get clusterrole traefik-ingress-controller`  
`kubectl get clusterrolebinding traefik-ingress-controller`

Expected output:

```
NAME                         AGE
traefik-ingress-controller   1m
```

You can apply the manifest:

`kubectl apply -f https://raw.githubusercontent.com/dysonfrost/kubernetes/master/traefik/traefik-manifest.yaml`

Some commands to make sure the traefik deployment is a success:

```
kubectl -n traefik get serviceaccounts
NAME                         SECRETS   AGE
default                      1         4m
traefik-ingress-controller   1         4m
```
```
kubectl -n traefik get configmaps traefik-conf
NAME           DATA   AGE
traefik-conf   1      4m
```
```
kubectl -n traefik get daemonsets
NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
traefik-ingress-controller   3         3         3       0            3           <none>          4m
```
```
kubectl -n traefik get services
NAME                      TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)        AGE
traefik-ingress-service   NodePort       10.152.183.142   <none>          80:30190/TCP   4m
traefik-web-ui            LoadBalancer   10.152.183.28    192.168.1.130   80:30966/TCP   4m
```
```
kubectl -n traefik get ingresses
NAME                HOSTS                   ADDRESS   PORTS   AGE
traefik-dashboard   traefik.detainedu.lan             80      4m
```
  
Make sure you have access to the dashboard using `traefik-web-ui` External-IP:

`curl http://traefik.mydomain`

Expected output:
```html
<a href="/dashboard/">Found</a>.
```

From now on, any time you want to expose a service with traefik, you'll need to add the following block at the end of your service manifest:

```YAML
# Traefik ingress support
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: traefik
    traefik.ingress.kubernetes.io/rule-type: "PathPrefixStrip"
  name: <ingress-name>
spec:
  rules:
  - host: service.mydomain
    http:
      paths:
      - path: /
        backend:
          serviceName: <service-name>
          servicePort: <frontend-port>
```


Connect to the traefik dashboard with your navigator and try to deploy a new service like [this whoami container](https://github.com/dysonfrost/kubernetes/tree/master/whoami).  
You should have access to the container using **the Traefik External-IP**

If you have an internal or public Domain Name Server like PowerDNS or BIND9, you can update your Zone File with a new entry for your containers, using a CNAME from traefik.mydomain.

