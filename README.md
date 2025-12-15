# Kubernetes Ingress – Real World Learning

This repo accompanies a Medium article documenting what I learned
building and debugging a multi-service Kubernetes setup.

## What this repo contains
- Frontend (NGINX)
- Backend API (Flask)
- Auth service (Flask)
- Ingress with host and path-based routing
- Local development using Minikube

## Structure
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

## How to run

**1. Start Minikube**
```bash
minikube start --driver=docker -p k8s-ingress
```

**2. Enable Ingress addon**
```bash
minikube addons enable ingress -p k8s-ingress
```

**3. Build images locally**
```bash
eval $(minikube docker-env -p k8s-ingress)
docker build -t frontend-app:1.0 ./frontend
docker build -t backend-app:1.0 ./backend
docker build -t auth-app:1.0 ./auth
```

**4. Apply manifests**
```bash
kubectl apply -f k8s/
```

**5. Set up host**
```bash
echo "127.0.0.1 demo-prakash.com" | sudo tee -a /etc/hosts
```

**6. Start tunnel (required for Docker driver on Mac)**
```bash
minikube tunnel -p k8s-ingress
```

**7. Test**
```bash
curl http://demo-prakash.com:8080/home
curl http://demo-prakash.com:8080/api
curl http://demo-prakash.com:8080/auth
```

## What I learned
- Ingress path-based routing
- Service port vs targetPort
- Port conflicts and custom port mapping
- Minikube tunnel for LoadBalancer services
- Debugging pods with kubectl exec

This repo is intentionally minimal and focuses on understanding
Ingress, Services, and request flow.
