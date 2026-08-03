# Rolling Updates & Rollbacks in Kubernetes ☸️

> Learn how Kubernetes updates applications **without downtime** using Deployments, ReplicaSets, and Rolling Updates.

---

# 🏗️ Architecture During a Rolling Update

```text
                 Deployment
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
 Old ReplicaSet                New ReplicaSet
   (v1)                           (v2)
   │ │ │                          │ │ │
 Old Pods                     New Pods
```

A Deployment never edits existing Pods.

Instead it:
1. Creates a new ReplicaSet.
2. Starts new Pods.
3. Gradually removes old Pods.
4. Completes the rollout.

---

# Sample Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
```

Apply:

```bash
kubectl apply -f deployment.yaml
```

---

# Verify Resources

```bash
kubectl get deployments
kubectl get rs
kubectl get pods
kubectl get pods -o wide
```

---

# Rolling Update

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.28

kubectl rollout status deployment/nginx-deployment

kubectl get pods -w

kubectl get rs -w
```

Observe:
- New ReplicaSet is created.
- New Pods start.
- Old Pods terminate gradually.
- Application remains available.

---

# Revision History

```bash
kubectl rollout history deployment/nginx-deployment
```

---

# Rollback

```bash
kubectl rollout undo deployment/nginx-deployment

kubectl get rs

kubectl get pods -w
```

---

# Useful Commands

```bash
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment
kubectl rollout restart deployment/nginx-deployment
kubectl describe deployment nginx-deployment
```

---

# Production Best Practices

- Use versioned image tags instead of `latest`.
- Verify rollout status after every deployment.
- Monitor application health during updates.
- Test changes in staging before production.
- Keep rollback plans ready.

---

# Common Mistakes

- Assuming Pods are modified in place.
- Deleting Pods manually during a rollout.
- Ignoring rollout status.
- Forgetting to check ReplicaSets.

---

# Interview Questions

1. What is a Rolling Update?
2. Why doesn't Kubernetes update Pods directly?
3. What is the role of a ReplicaSet during updates?
4. Which command checks rollout status?
5. How do you rollback a Deployment?
6. Why are Rolling Updates preferred in production?

---

# Key Takeaways

- Deployments manage ReplicaSets.
- ReplicaSets manage Pods.
- Rolling Updates replace Pods gradually.
- Rollbacks restore a previous working revision.
- Kubernetes minimizes downtime during deployments.

Happy Learning! 

**Shubham Gour Tech**
