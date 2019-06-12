# KUBE-STATE-METRICS
kube-state-metrics is a simple service that listens to the Kubernetes API server and generates metrics about the state of the objects. (See examples in the Metrics section below.) It is not focused on the health of the individual Kubernetes components, but rather on the health of the various objects inside, such as deployments, nodes and pods.

kube-state-metrics is about generating metrics from Kubernetes API objects without modification. This ensures that features provided by kube-state-metrics have the same grade of stability as the Kubernetes API objects themselves. In turn, this means that kube-state-metrics in certain situations may not show the exact same values as kubectl, as kubectl applies certain heuristics to display comprehensible messages. kube-state-metrics exposes raw data unmodified from the Kubernetes API, this way users have all the data they require and perform heuristics as they see fit.

The metrics are exported on the HTTP endpoint `/metrics` on the listening port (default 80). They are served as plaintext. They are designed to be consumed either by Prometheus itself or by a scraper that is compatible with scraping a Prometheus client endpoint. You can also open `/metrics` in a browser to see the raw metrics.

## Prerequisites

kube-state-metrics is a project written in `GO`.  
You must have the package `golang` and `docker-ce` installed and configured.

## Setup

Install this project to your `$GOPATH` using `go get`:

```sh
go get k8s.io/kube-state-metrics
```

## Building the Docker container

Simply run the following command in this root folder, which will create a self-contained, statically-linked binary and build a Docker image

```sh
make container
```

Connect to the `manager` virtual machine and simply build and run kube-state-metrics inside a Kubernetes pod.


## Config files related to traefik for 5ESGI-PA

To deploy this project, you can simply run `kubectl apply -f kubernetes` and a Kubernetes service and deployment will be created. 

```sh
cd go/src/k8s.io/kube-state-metrics
kubectl apply -f kubenernetes
```

*For more informations, please visit the [kube-state-metrics github project](https://github.com/kubernetes/kube-state-metrics)*