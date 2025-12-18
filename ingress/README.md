# Kubernetes Manifests

## Services
- **frontend-service** (port 7000 → targetPort 80)
- **backend-service** (port 5000 → targetPort 5000)
- **auth-service** (port 4000 → targetPort 4000)

## Ingress Routes
- `/home` → frontend-service:7000
- `/api` → backend-service:5000
- `/auth` → auth-service:4000

Host: `demo-prakash.com`

## Apply all
```bash
kubectl apply -f k8s/
```

## Check status
```bash
kubectl get pods,svc,ingress
```
