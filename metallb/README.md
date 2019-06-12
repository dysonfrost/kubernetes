# METALLB
MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.

*For more informations, please visit [MetalLB official website](https://metallb.universe.tf/)*

## Installation with Kubernetes manifests

To install MetalLB, simply apply the manifest:

`kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml`

This will deploy MetalLB to your cluster, under the `metallb-system` namespace. The components in the manifest are:

- The `metallb-system/controller` deployment. This is the cluster-wide controller that handles IP address assignments.
- The `metallb-system/speaker` daemonset. This is the component that speaks the protocol(s) of your choice to make the services reachable.
- Service accounts for the controller and speaker, along with the RBAC permissions that the components need to function.

The installation manifest does not include a configuration file. MetalLB’s components will still start, but will remain idle until you [define and deploy a configmap](#config-files-related-to-metallb-for-5esgi-pa).

## Config files related to metallb for 5ESGI-PA

- layer2-config.yaml

MetalLB’s configuration is a standard Kubernetes ConfigMap, config under the metallb-system namespace. It contains two pieces of information: what IP addresses it’s allowed to hand out and which protocol to do that with.

In this configuration we tell MetalLB to hand out address from the `192.168.1.130-192.168.1.199` range, using layer 2 mode (`protocol: layer2`). 

Please connect to the `manager` virtual machine and apply this configuration:

`kubectl apply -f https://raw.githubusercontent.com/dysonfrost/metallb/master/layer2-config.yaml`

The configuration should take effect within a few seconds. By following the logs we can see what’s going on: `kubectl logs -l component=speaker -n metallb-system`:

```sh
{"caller":"main.go:159","event":"startUpdate","msg":"start of service update","service":"kube-system/metrics-server","ts":"2019-05-26T14:45:23.927962858Z"}
{"caller":"main.go:163","event":"endUpdate","msg":"end of service update","service":"kube-system/metrics-server","ts":"2019-05-26T14:45:23.927977795Z"}
...
{"caller":"main.go:229","event":"serviceAnnounced","ip":"192.168.1.130","msg":"service has IP, announcing","pool":"my-ip-space","protocol":"layer2","service":"default/nginx","ts":"2019-05-26T14:45:26.805510675Z"}
```
- test-nginx-pod.yaml

This file contains a trivial service: an nginx pod, and a load-balancer service pointing at nginx. Deploy it to the cluster:

`kubectl apply -f https://raw.githubusercontent.com/dysonfrost/metallb/master/test-nginx-pod.yaml`

Wait for nginx to start by monitoring `kubectl get pods`, until you see a running nginx pod. It should look something like this:

```
NAME                     READY   STATUS    RESTARTS   AGE
nginx-58df4bbfdd-4ccbx   1/1     Running   0          24h
```

Once it’s running, take a look at the nginx service with `kubectl get service nginx`:
```shell
NAME    TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
nginx   LoadBalancer   10.152.183.18   192.168.1.130   80:31743/TCP   24h
```
We have an external IP! 

MetalLB is using the first address of the assigned range (192.168.1.130).

When you `curl http://192.168.1.130` you should see the default nginx page: “Welcome to nginx!”



