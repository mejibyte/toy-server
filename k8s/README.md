# Apply objects

```
$ kubectl diff -f k8s/
$ kubectl apply -f k8s/
```

# Get objects

```
$ kubectl get -f k8s/
```

# Delete objects

```
$ kubectl delete -f k8s/
```

# Seeing Service

After creating Service, run:

```
$ minikube service toy-server-service1
```