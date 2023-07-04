# Installing.

using the global script to install on linux, mac or windows:


# Creating Cluster example
```
docker run --privileged --rm -it --name kk  \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --net=host \
  -e "KK_AUTO_CREATION_FILE=/tmp/autodeploy-example.yml" \
  -v $PWD/autodeploy-example.yml:/tmp/autodeploy-example.yml \
  -v $HOME/.kube/config:/root/.kube/config \
  brpedromaia/kk:v2 bash
```

# TO DO: Proper Readme.md 

# Endpoints:
### With autodeploy:
```
curl -s https://playground.rec.la/health
curl -s https://playground.rec.la/books/ |jq
```

### Optionals:
```
# inside kk container:
# kubectl apply -n myns -f /usr/local/kind-container/examples/apps/
curl -s https://playground.rec.la/hello
curl -s https://playground.rec.la/agnhost
```