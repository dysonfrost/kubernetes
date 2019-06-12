# MINIO
MinIO is an object storage server released under Apache License v2.0. It is compatible with Amazon S3 cloud storage service. It is best suited for storing unstructured data such as photos, videos, log files, backups and container / VM images. Size of an object can range from a few KBs to a maximum of 5TB.

MinIO server is light enough to be bundled with the application stack, similar to NodeJS, Redis and MySQL.

*For more informations, please visit [MinIO official website](https://min.io/)*

## Prerequisites

### Check the presence of the label `storage` in the kubernetes configuration

```sh
kubectl get nodes --show-labels | grep storage
```


### Install minio on a Kubernetes cluster

To install minio on a kubernetes cluster, you need to declare a label on the worker of your choice.

Example:

```sh
kubectl label nodes <node-name> <label>=<value>
```

Please connect to the `manager` virtual machine and apply this configuration:

```sh
kubectl label nodes juju-ea0acb-11 kind=storage
```

Finally, connect to the `worker` where the label has been applied and create a directory for minio to store data.

```sh
mkdir -p /opt/storage
```

## Config files related to minio for 5ESGI-PA

- minio-manifest.yaml

This manifest is divided into 4 distinct blocks:

1) PersistentVolume

A `PersistentVolume` (PV) is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes. It is a resource in the cluster just like a node is a cluster resource. PVs are volume plugins like Volumes, but have a lifecycle independent of any individual pod that uses the PV. This API object captures the details of the implementation of the storage, be that NFS, iSCSI, or a cloud-provider-specific storage system.

2) PersistentVolumeClaim

A `PersistentVolumeClaim` (PVC) is a request for storage by a user. It is similar to a pod. Pods consume node resources and PVCs consume PV resources. Pods can request specific levels of resources (CPU and Memory). Claims can request specific size and access modes (e.g., can be mounted once read/write or many times read-only).

3) Service

An abstract way to `expose an application` running on a set of Pods as a network service.

No need to modify your application to use an unfamiliar service discovery mechanism. Kubernetes gives pods their own IP addresses and a single DNS name for a set of pods, and can load-balance across them.

4) Deployments

A `Deployment controller` provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment object, and the Deployment controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

To deploy minio, simply run

```sh
kubectl apply -f https://raw.githubusercontent.com/dysonfrost/kubernetes/master/minio/minio-manifest.yaml
```
