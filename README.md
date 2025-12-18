# Kubernetes Ingress – Multi-Service Demo

Multi-service Kubernetes setup with Ingress routing.

## Services

| Service   | Port | Path           | Domain              |
|-----------|------|----------------|---------------------|
| Frontend  | 3000 | /              | ui.demo.com         |
| Backend   | 4000 | /api           | backend.demo.com    |
| Auth      | 5000 | /              | auth.demo.com       |

## Quick Start

```bash
# Deploy everything
./deploy.sh
```

## Manual Deployment

**1. Start Minikube**
```bash
minikube start --driver=docker
```

**2. Enable Ingress**
```bash
minikube addons enable ingress
```

**3. Build images**
```bash
docker build -t frontend-app:2.0 frontend/
docker build -t backend-app:1.0 backend/
docker build -t auth-app:1.0 auth/
```

**4. Load to Minikube**
```bash
minikube image load frontend-app:2.0
minikube image load backend-app:1.0
minikube image load auth-app:1.0
```

**5. Apply manifests**
```bash
kubectl apply -f k8s/
```

**6. Update /etc/hosts**
```bash
echo "$(minikube ip) ui.demo.com backend.demo.com auth.demo.com" | sudo tee -a /etc/hosts
```

**7. Access**
- Frontend: http://ui.demo.com
- Backend: http://backend.demo.com/api
- Auth: http://auth.demo.com

## Project Structure

```
k8s-multi-service-ingress/
├── frontend/
│   ├── app.py
│   ├── index.html
│   └── Dockerfile
├── backend/
│   ├── app.py
│   └── Dockerfile
├── auth/
│   ├── app.py
│   └── Dockerfile
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── auth-deployment.yaml
│   ├── auth-service.yaml
│   └── ingress.yaml
├── deploy.sh
└── README.md
```

## Troubleshooting

```bash
# Check status
kubectl get all
kubectl get ingress

# View logs
kubectl logs -f deployment/frontend
kubectl logs -f deployment/backend
kubectl logs -f deployment/auth

# Debug pods
kubectl describe pod <pod-name>
```

## MongoDB StatefulSet

**Initialize replica set:**
```bash
kubectl exec -it mongo-0 -n demo -- mongosh -u admin -p password
```

```javascript
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongo-0.mongo.demo.svc.cluster.local:27017" },
    { _id: 1, host: "mongo-1.mongo.demo.svc.cluster.local:27017" },
    { _id: 2, host: "mongo-2.mongo.demo.svc.cluster.local:27017" }
  ]
})
```

**Connect from MongoDB Compass:**
```bash
# Port-forward mongo-0
kubectl port-forward mongo-0 -n demo 27017:27017

# Connection string:
mongodb://admin:password@localhost:27017/?directConnection=true
```


- understand omni flo in infra level. (application plays vital part). how wms2 flow is there. (major change account flow)
- proxy & integration
- infra


existin client
- repro
    - have only cims, wms, sfs -> need wms2
- k8s (add 1 sub obj wms2 in base helm chart)
- should chng helm chart (lvl 1)
- accnt server - 2 not 1
- wms only has acnt server 2
- `TODO: credential`


- thursday
- set up a meeting