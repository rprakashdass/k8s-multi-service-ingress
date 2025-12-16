# K8s Multi-Service Ingress - Production Ready

Production-grade Kubernetes multi-service application with Ingress routing, health checks, and industry best practices.

## Architecture

```
                    ┌─────────────────┐
                    │  Ingress (NGINX) │
                    └────────┬─────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼────┐         ┌─────▼────┐        ┌─────▼────┐
   │ Frontend│         │ Backend  │        │   Auth   │
   │  :3000  │────────▶│  :4000   │        │  :5000   │
   └─────────┘         └──────────┘        └──────────┘
```

## Services Overview

| Service   | Port | Path           | Domain              |
|-----------|------|----------------|---------------------|
| Frontend  | 3000 | /              | ui.demo.com         |
| Backend   | 4000 | /api           | backend.demo.com    |
| Auth      | 5000 | /              | auth.demo.com       |

## Quick Start - One Command Deployment

```bash
# Deploy everything at once
./deploy.sh
```

The script handles:
-  Building all Docker images
-  Loading images to Minikube
-  Deploying all Kubernetes resources
-  Displaying deployment status

## Manual Deployment

**1. Start Minikube**
```bash
minikube start --driver=docker
```

**2. Enable Ingress addon**
```bash
minikube addons enable ingress
```

**3. Build Docker images**
```bash
docker build -t frontend-app:2.0 frontend/
docker build -t backend-app:1.0 backend/
docker build -t auth-app:1.0 auth/
```

**4. Load images to Minikube**
```bash
minikube image load frontend-app:2.0
minikube image load backend-app:1.0
minikube image load auth-app:1.0
```

**5. Apply Kubernetes manifests**
```bash
kubectl apply -f k8s/
```

**6. Update /etc/hosts**
```bash
echo "$(minikube ip) ui.demo.com backend.demo.com auth.demo.com" | sudo tee -a /etc/hosts
```

**7. Access services**
- Frontend: http://ui.demo.com
- Backend: http://backend.demo.com/api
- Auth: http://auth.demo.com

## Production Features

 **Security**
- Non-root containers (user 1000)
- Resource limits and requests
- Minimal base images (Python 3.11-slim)

 **Performance**
- Gunicorn WSGI server (4 workers)
- Multi-stage Docker builds
- Optimized dependency caching

 **Reliability**
- Liveness probes (container health)
- Readiness probes (traffic readiness)
- Health check endpoints
- Graceful shutdowns
```
k8s-realworld-ingress/
├── frontend/
│   ├── Dockerfile
│   └── index.html
├── backend/
│   ├── Dockerfile
│   └── app.py
├── auth/
│   ├── Dockerfile
│   └── app.py
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── auth-deployment.yaml
│   ├── auth-service.yaml
│   └── ingress.yaml
└── README.md
```

## Project Structure

```
k8s-multi-service-ingress/
├── frontend/
│   ├── app.py              # Flask frontend app
│   ├── index.html          # HTML template
│   ├── Dockerfile          # Production Dockerfile
│   └── requirements.txt    # Python dependencies
├── backend/
│   ├── app.py              # Flask backend API
│   ├── Dockerfile          # Production Dockerfile
│   └── requirements.txt    # Python dependencies
├── auth/
│   ├── app.py              # Flask auth service
│   ├── Dockerfile          # Production Dockerfile
│   └── requirements.txt    # Python dependencies
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── auth-deployment.yaml
│   ├── auth-service.yaml
│   └── ingress.yaml        # Multi-host ingress rules
├── deploy.sh               # Automated deployment script
└── README.md
```

## Configuration Details

### Port Configuration (All Fixed )
- **Frontend**: App:3000 → Service:3000 → Ingress:3000
- **Backend**: App:4000 → Service:4000 → Ingress:4000
- **Auth**: App:5000 → Service:5000 → Ingress:5000

### Resource Limits (Per Pod)
```yaml
requests:
  memory: "128Mi"
  cpu: "100m"
limits:
  memory: "256Mi"
  cpu: "200m"
```

### Health Checks
- **Liveness**: Every 10s after 10s delay
- **Readiness**: Every 5s after 5s delay

## Development

### Run Services Locally

```bash
# Frontend
cd frontend && pip install -r requirements.txt && python app.py

# Backend
cd backend && pip install -r requirements.txt && python app.py

# Auth
cd auth && pip install -r requirements.txt && python app.py
```

## Troubleshooting

### Check deployment status
```bash
kubectl get all
kubectl get ingress
```

### View pod logs
```bash
kubectl logs -f deployment/frontend
kubectl logs -f deployment/backend
kubectl logs -f deployment/auth
```

### Debug pods
```bash
kubectl describe pod <pod-name>
kubectl exec -it <pod-name> -- /bin/sh
```

### Test service connectivity
```bash
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
wget -O- http://frontend-service:3000
wget -O- http://backend-service:4000/api
wget -O- http://auth-service:5000
```

### Common Issues

**Port mismatch errors**: All ports have been validated and fixed 

**Ingress not working**: 
```bash
kubectl get ingress
kubectl describe ingress main-ingress
```

**Pods not starting**:
```bash
kubectl get pods
kubectl describe pod <pod-name>
```

## What This Project Demonstrates

 Multi-service Kubernetes architecture
 Ingress with host-based routing
 Health checks (liveness + readiness probes)
 Resource management
 Production-ready Dockerfiles
 Non-root container security
 Proper port configuration across all layers
 Industry-standard deployment practices

## License

MIT

