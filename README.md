# Requirements:

Docker > 20.0
```
docker --version
Docker version 24.0.2, build cb74dfc
```

# Notes:
> It's fully tested only in MacOS (Intel)

> Pending tests: Win & Lin
# How kk framework works:

It's a containirised framework to help the kubernetes cluster locally with examples.
There are two ways to use that:

1. Command line
2. Automated Feature from yaml file

# Creating K8s Cluster with command line:

## Starting kk-framework container
```
docker run --privileged --rm -it --name kk \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.kube/config:/root/.kube/config \
  --net=host \
  alpine-docker:latest  
  brpedromaia/kk:v3
kk bootstrap cluster --workers 3 --name mycluster --bootstrap nginx,argocd --plan --apply
[ 🐳 none 🏷  none ]$
```
docker run --privileged --rm -it --name kk   -v $PWD/modules/cluster/bootstrap:/opt/kk/modules/cluster/bootstrap -v /var/run/docker.sock:/var/run/docker.sock   -v $HOME/.kube/config:/root/.kube/config   --net=host   alpine-docker:latest  
k bootstrap cluster myname --bootstrap nginx,argocd --namespaces myapps,monitoring --apply
k bootstrap namespace myname --bootstrap nginx,argocd --namespaces myapps,monitoring --apply
### Why should I use that into my container run command?
| Parameter | Description |
| :---: | :---: |
| -v /var/run/docker.sock:/var/run/docker.sock | this is required to create the cluster using docker service from host|
| -v $HOME/.kube/config:/root/.kube/config | this is optional, used to append the k8s cluster context into your localmachine kubeconfig |
| --net=host | this is optional but good, used to access the localhost endpoints (exposed by k8s cluster) from your machine |


## Usage kk-framework container
kk with autocompletion:

```
[ 🐳 none 🏷  none ]$ kk
Usage:
    kk [command] [args]


Helpers:
    cluster --help       Cluster Managemen Commands


[ 🐳 none 🏷  none ]$ 
```

### kk Cluster Management Commands Usage:
```
[ 🐳 none 🏷  none ]$  kk cluster --help
Usage:
    kk [command] cluster [args]

kk Cluster Management Commands:
    
    Cluster Creation:

    kk create cluster [args]:         To create a new k8s cluster (kind)
      -n='' | --name=''               Cluster Name [ Required ]
      
      Optionals:

      -w='' | --workers=''            Number of nodes, default is 0
      --bootstrap_nginx               To create the cluster nginx ingress from framework bootstrap
      --dryrun | --plan               Run in dryrun mode, creating files inside the default plan folder (/root/.kk/)
      -y| --yes | --apply             To Assume yes; assume that the answer to any question which would be asked is yes.
      -d='' | --folder=''             To Run the created plan from specific directory

    e.g.: kk create cluster --workers=3 --name=mycluster --bootstrap_nginx

    Cluster Info:

    kk cluster
    kk get cluster                    Display cluster information

    

    Cluster Deletion:

    kk delete cluster [cluster name]  To delete a k8s cluster (kind)
```

### Creating my first cluster:

```
kk create cluster --workers=3 --name=mycluster --bootstrap_nginx
```

<details>
  <summary> click to expand the output </summary>
  ```
  Cluster Creation Plan:

  file: //root/.kk//mycluster/kk-cluster.yml
  cluster:
    name: mycluster
    workers: 3
    autocreation: yes
    ingress: bootstrap_nginx

  Apply this plan (y/n)? y
  No kind clusters found.
  Creating cluster "mycluster" ...
  ✓ Ensuring node image (kindest/node:v1.27.3) 🖼
  ✓ Preparing nodes 📦 📦 📦 📦  
  ✓ Writing configuration 📜 
  ✓ Starting control-plane 🕹️ 
  ✓ Installing CNI 🔌 
  ✓ Installing StorageClass 💾 
  ✓ Joining worker nodes 🚜 
  Set kubectl context to "kind-mycluster"
  You can now use your cluster with:

  kubectl cluster-info --context kind-mycluster

  Have a nice day! 👋

  Starting kk nginx bootstrap...

  namespace/ingress-nginx created
  serviceaccount/ingress-nginx created
  serviceaccount/ingress-nginx-admission created
  role.rbac.authorization.k8s.io/ingress-nginx created
  role.rbac.authorization.k8s.io/ingress-nginx-admission created
  clusterrole.rbac.authorization.k8s.io/ingress-nginx created
  clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
  rolebinding.rbac.authorization.k8s.io/ingress-nginx created
  rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
  clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
  clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
  configmap/ingress-nginx-controller created
  service/ingress-nginx-controller created
  service/ingress-nginx-controller-admission created
  deployment.apps/ingress-nginx-controller created
  job.batch/ingress-nginx-admission-create created
  job.batch/ingress-nginx-admission-patch created
  ingressclass.networking.k8s.io/nginx created
  validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
  pod/ingress-nginx-controller-79c9f858b4-f7tp6 condition met
  
  🥰 Cool! kk framework has delivered your kind cluster
  🚀 mycluster cluster is ready to use!

  👋 Enjoy! Cheers

  ```
</details>

## Running the orchestratror container:
```
docker run --privileged --rm -it --name kk  \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --net=host \
  -e "KK_AUTO_CREATION_FILE=/tmp/autodeploy-example.yml" \
  -v $PWD/autodeploy-example.yml:/tmp/autodeploy-example.yml \
  -v $HOME/.kube/config:/root/.kube/config \
  brpedromaia/kk:v2 bash
```
