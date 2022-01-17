Api Deployment
===

Using
---

You'll need the following dependencies:

- Docker
- Kubernetes

A little work need to be done to achieve the deployment. The two `api-secret.example.yaml` and `mongo-secret.example.yaml` files must be renamed without the `.example` suffix and must contain their respective secrets encoded in base 64. Also, be sure to have a ssl certificate to enable https.

Once done, run `./setup.sh` to clone the api project, then follow the lines to properly deploy the Minimouli api:

```bash
# Build the api project with Docker
docker build -t api .

# Start a local Docker registry
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# Push the docker image to the local registry
docker tag api localhost:5000/api
docker push localhost:5000/api

cd k8s

# Setup more Kubernetes object to store data
kubectl create configmap mongo-initdb --from-file=./scripts/init-mongo.sh
kubectl create secret tls api-minimouli-com-tls --cert=CERT_FILE --key=KEY_FILE

# Deploy MongoDB inside Kubernetes
kubectl apply -f mongo-config.yaml -f mongo-secret.yaml
kubectl apply -f mongo-volume.yaml
kubectl apply -f mongo-deployment.yaml
kubectl apply -f mongo-service.yaml

# Deploy the api inside Kubernetes
kubectl apply -f api-config.yaml -f api-secret.yaml
kubectl apply -f api-deployment.yaml
kubectl apply -f api-service.yaml
kubectl apply -f api-ingress.yaml
```
