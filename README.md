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
kk bootstrap cluster mycluster --workers 3 --bootstrap nginx,argocd --namespaces myapps, --apply
[ 🐳 none 🏷  none ]$
```
### Why should I use that into my container run command?
| Parameter | Description |
| :---: | :---: |
| -v /var/run/docker.sock:/var/run/docker.sock | this is required to create the cluster using docker service from host|
| -v $HOME/.kube/config:/root/.kube/config | this is optional, used to append the k8s cluster context into your localmachine kubeconfig |
| --net=host | this is optional but good, used to access the localhost endpoints (exposed by k8s cluster) from your machine |


## Usage kk-framework container
kk with autocompletion:

kk usage

<details>
<summary> click to expand </summary>

```
[ 🐳 none 🏷  none ]$ kk
Usage:
    kk <module> <resource> <args>


    Use kk <module> --help           for more information about a given command.
    
    Modules:

      bootstrap                       To create resources quickly
                                      resources: cluster, namespace

      ct | context                    To quickly manage k8s contexts

      ns | namespace                  To quickly manage k8s namespace

      ns | namespace                  To quickly release k8s resources to cluster

      cluster                         To quickly manage kind cluster
                                      flags: 
                                        get     Display cluster information
                                        delete  To delete a k8s cluster (kind)
                                      usage: kk <flag> cluster <cluster name>


[ 🐳 none 🏷  none ]$ 
```
</details>

### kk bootstrap usage:

<details>
<summary> click to expand </summary>
  
```
[ 🐳 none 🏷  none ]$  kk bootstrap 
Usage:
    kk bootstrap [resource] [args]

kk Cluster Management Commands:
    
    Resources:

      cluster [cluster name ]         To create a new k8s cluster (kind)
        args:
          --workers 1..10             Number of nodes, default is 0
          --bootstrap item1,item2     To quick create a new cluster with working tools
                                      options: nginx argocd
                                      e.g.: kk bootstrap cluster mycluster --workers 3 --bootstrap nginx,argocd
          --namespaces                To quick create the kk namespaces
                                      options: monitoring,myapps
                                      e.g.: kk bootstrap cluster mycluster --workers 3 --bootstrap nginx,argocd --namespaces monitoring,myapps
      namespace
        args:
          -c | --cluster              Number of nodes, default is 0
                                      e.g. kk bootstrap namespace -c myapps -f myapps.yml
    Bootstrap args:   
      --plan                          Run in plan (dry run) mode, creating files inside the default plan folder (/root/.kk/)
      --apply                         To Assume yes; assume that the answer to any question which would be asked is yes.
      -f='' | --file=''               To Run a created plan from specific file

    e.g.: kk bootstrap cluster mycluster --workers 3 --bootstrap nginx,argocd --namespaces monitoring,myapps

    Cluster Info:

    kk cluster
    kk get cluster                    Display cluster information

    

    Cluster Deletion:

    kk delete cluster [cluster name]  To delete a k8s cluster (kind)
```

</details>

### Creating my first cluster:

```
kk bootstrap cluster mycluster --workers 3 --bootstrap nginx,argocd --apply
```

<details>
<summary> click to expand the output </summary>

```
Cluster Creation Plan:

file: /root/.kk/mycluster.yml
version: v1-alpha
cluster:
  name: mycluster
  workers: 3
  autocreation: auto
  plan:
    from_file: /root/.kk/mycluster.yml
Setting up the Nginx Ingress 🌐
Cool! kk framework has delivered your kind cluster 🥰 
mycluster cluster is ready to use!🚀

Enjoy! Cheers 👋


```

</details>

### Creating my first cluster with example apps:

```
kk bootstrap cluster mycluster --workers 3 --bootstrap nginx,argocd --namespaces myapps, --apply
```

<details>
<summary> click to expand the output </summary>

```
Cluster Creation Plan:

file: /root/.kk/mycluster.yml
version: v1-alpha
cluster:
  name: mycluster
  workers: 3
  bootstrap:
    - name: nginx
      enabled: "yes"
    - name: argocd
      enabled: "yes"
  namespaces:
    - name: myapps
      enabled: "yes"
  autocreation: auto
  plan:
    from_file: /root/.kk/mycluster.yml
Applying the approved plan...
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
Setting up the Nginx Ingress 🌐
Setting Argocd from kk bootstrap 🐙
your argocd is ready: https://argocd.rec.la 🚜
User: admin Password: Password123 🪪
myapps namespace apps have been released ✅ 
Cool! kk framework has delivered your kind cluster 🥰 
mycluster cluster is ready to use!🚀

Enjoy! Cheers 👋


```
</details>

#### Testing example apps:

##### Openresty:
```
curl -s https://playground.rec.la/health
```

<details>
<summary> click to expand the output </summary>

```
{"status":"UP"}
```

</details>

##### Hello:
```
curl -s https://playground.rec.la/hello
```

<details>
<summary> click to expand the output </summary>

```
Hello World
```

</details>

##### agnhost:
```
curl -s https://playground.rec.la/agnhost
```

<details>
<summary> click to expand the output </summary>

```
NOW: 2023-07-09 00:54:11.919462633 +0000 UTC m=+22.42053851
```

</details>

##### Books:
```
curl -s https://playground.rec.la/books/ |yq -P
```

<details>
<summary> click to expand the output </summary>

```yml
metadata:
  pageSize: 2
  currentPage: 0
  totalPages: 1
  totalRecord: 2
  orderby: id
  sort: ASC
result:
  - author: J. R. R. Tolkien
    id: B0001
    publication_year: 1937
    name: The Hobbit
    genre: Fantasy
  - author: J. K. Rowling
    id: B0002
    publication_year: 1997
    name: Harry Potter and the Philosopher's Stone
    genre: Fantasy
```

</details>

# TODO:
- [ ] autocomplete bugs
- [ ] command line [cluster]
- [ ] manual cd withou argocd
- [ ] m1 build
- [ ] tests with linux & mac
- [ ] tools version doc