# Kubeconfig

- Actualizamos el kubeconfig para conectarnos al cluster

```
aws eks update-kubeconfig --name <<REEMPLAZAR_NOMBRE_CLUSTER>>
```

```
kubectl config view --minify
```

```
~/.kube/config
```