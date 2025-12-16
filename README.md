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
