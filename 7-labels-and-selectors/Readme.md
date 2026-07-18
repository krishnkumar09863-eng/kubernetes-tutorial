# Kubernetes Labels & Selectors Explained

## Labels

Labels are key-value pairs attached to Kubernetes resources.

```yaml
labels:
  app: web
  env: dev
  version: v1
```

## Why Labels?

- Organize resources
- Filter resources
- Help Services find Pods
- Help ReplicaSets manage Pods

## Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  labels:
    app: web
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx
```

Apply:

```bash
kubectl apply -f pod.yaml
```

View labels:

```bash
kubectl get pods --show-labels
```

## Selectors

Equality:

```bash
kubectl get pods -l app=web
```

Set Based:

```bash
kubectl get pods -l 'env in (dev,prod)'
```

## Summary

Labels identify Kubernetes resources.

Selectors search resources based on labels.

ReplicaSets and Services use selectors to manage traffic and Pods.

Happy Learning!

YouTube: Shubham Gour Tech
