#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Multi-Service Deployment Script${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Step 1: Build Docker images
echo -e "${YELLOW}[1/4] Building Docker images...${NC}"
echo -e "${GREEN}Building auth service...${NC}"
docker build -t auth-app:1.0 auth/
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build auth-app${NC}"
    exit 1
fi

echo -e "${GREEN}Building backend service...${NC}"
docker build -t backend-app:1.0 backend/
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build backend-app${NC}"
    exit 1
fi

echo -e "${GREEN}Building frontend service...${NC}"
docker build -t frontend-app:2.0 frontend/
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build frontend-app${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All images built successfully!${NC}\n"

# Step 2: Load images to Minikube (if using Minikube)
echo -e "${YELLOW}[2/4] Loading images to Kubernetes cluster...${NC}"
if command -v minikube &> /dev/null; then
    echo -e "${GREEN}Detected Minikube - loading images...${NC}"
    minikube image load auth-app:1.0
    minikube image load backend-app:1.0
    minikube image load frontend-app:2.0
    echo -e "${GREEN}✓ Images loaded to Minikube!${NC}\n"
else
    echo -e "${YELLOW}Minikube not detected, skipping image load...${NC}\n"
fi

# Step 3: Apply Kubernetes manifests
echo -e "${YELLOW}[3/4] Deploying to Kubernetes...${NC}"

echo -e "${GREEN}Applying deployments...${NC}"
kubectl apply -f k8s/auth-deployment.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml

echo -e "${GREEN}Applying services...${NC}"
kubectl apply -f k8s/auth-service.yaml
kubectl apply -f k8s/backend-service.yaml
kubectl apply -f k8s/frontend-service.yaml

echo -e "${GREEN}Applying ingress...${NC}"
kubectl apply -f k8s/ingress.yaml

echo -e "${GREEN}✓ All resources applied!${NC}\n"

# Step 4: Check deployment status
echo -e "${YELLOW}[4/4] Checking deployment status...${NC}"
sleep 3
kubectl get deployments
echo ""
kubectl get services
echo ""
kubectl get ingress

echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}To watch pod status:${NC}"
echo -e "  kubectl get pods -w\n"

echo -e "${YELLOW}To access services (add to /etc/hosts):${NC}"
echo -e "  $(minikube ip 2>/dev/null || echo '<minikube-ip>')  ui.demo.com backend.demo.com\n"

echo -e "${YELLOW}Service URLs:${NC}"
echo -e "  Frontend: http://ui.demo.com"
echo -e "  Backend:  http://backend.demo.com"
