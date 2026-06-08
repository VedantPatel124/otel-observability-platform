# OpenTelemetry Observability Platform on AWS EKS

## Project Overview

This project demonstrates the deployment of a cloud-native microservices application on AWS EKS using Infrastructure as Code, Kubernetes, Docker, and CI/CD automation.

The application is based on the OpenTelemetry Demo and serves as a real-world workload for implementing modern DevOps practices on AWS.

The project showcases:

* Infrastructure provisioning using Terraform
* Kubernetes deployment on Amazon EKS
* Docker containerization
* CI/CD automation using GitHub Actions
* Automated Docker image build and push workflows
* Kubernetes deployment manifest updates
* Modular Infrastructure as Code design

---

## Disclaimer

This project uses the OpenTelemetry Demo application as the sample microservices workload.

The primary focus of this repository is demonstrating DevOps practices including Infrastructure as Code, Kubernetes orchestration, CI/CD automation, containerization, and AWS cloud infrastructure deployment.

---

## Key Features

* Provision AWS infrastructure using Terraform
* Deploy Amazon EKS clusters using reusable Terraform modules
* Deploy microservices using Kubernetes manifests
* Containerize services using Docker
* Automate build, test, and deployment workflows using GitHub Actions
* Build and publish Docker images automatically
* Maintain Infrastructure as Code using Terraform modules
* Deploy a production-style microservices application

---

## Architecture

```text
GitHub Repository
        │
        ▼
GitHub Actions
        │
        ▼
Docker Build & Push
        │
        ▼
Docker Hub
        │
        ▼
AWS Infrastructure (Terraform)
        │
        ▼
Amazon EKS Cluster
        │
        ▼
Kubernetes Deployment
        │
        ▼
OpenTelemetry Demo Microservices
```

---

## Technology Stack

### Cloud

* AWS EKS
* AWS VPC
* AWS IAM
* AWS S3

### Infrastructure as Code

* Terraform

### Containerization

* Docker
* Docker Compose

### Container Orchestration

* Kubernetes

### CI/CD

* GitHub Actions

### Languages & Frameworks

* Go
* Java
* Python
* JavaScript
* TypeScript
* .NET

---

## Repository Structure

```text
otel-observability-platform
│
├── .github/
│   └── workflows/
│
├── terraform/
│   ├── backend/
│   ├── modules/
│   │   ├── eks/
│   │   └── vpc/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── kubernetes/
│
├── app/
│   └── opentelemetry-demo/
│       ├── src/
│       ├── pb/
│       ├── internal/
│       ├── test/
│       ├── docker-compose.yml
│       ├── docker-compose.minimal.yml
│       └── Makefile
│
├── README.md
├── .gitignore
└── .dockerignore
```

---

## Prerequisites

Install the following tools:

* AWS CLI
* Terraform
* kubectl
* Docker Desktop
* Git

Verify installation:

```bash
aws --version
terraform --version
kubectl version --client
docker --version
git --version
```

---

# Deployment Guide

## Step 1: Clone Repository

```bash
git clone https://github.com/VedantPatel124/otel-observability-platform.git

cd otel-observability-platform
```

---

## Step 2: Configure AWS Credentials

```bash
aws configure
```

Provide:

```text
AWS Access Key ID
AWS Secret Access Key
Region
Output Format
```

Verify configuration:

```bash
aws sts get-caller-identity
```

---

## Step 3: Create Terraform Backend

Navigate to backend configuration:

```bash
cd terraform/backend
```

Initialize Terraform:

```bash
terraform init
```

Create backend resources:

```bash
terraform apply -auto-approve
```

Resources created:

* S3 Bucket for Terraform State
* Remote State Backend Configuration

---

## Step 4: Provision AWS Infrastructure

Navigate to Terraform root directory:

```bash
cd ..
```

Initialize Terraform:

```bash
terraform init
```

Review execution plan:

```bash
terraform plan
```

Deploy infrastructure:

```bash
terraform apply -auto-approve
```

Resources created:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Amazon EKS Cluster
* EKS Managed Node Group

---

## Step 5: Configure kubectl

Connect kubectl to EKS:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name demo-eks-cluster
```

Verify cluster access:

```bash
kubectl get nodes
```

Expected output:

```text
STATUS: Ready
```

---

## Step 6: Deploy Application

Navigate to Kubernetes manifests:

```bash
cd ../kubernetes
```

Deploy all services:

```bash
kubectl apply -f complete-deploy.yaml
```

Verify deployment:

```bash
kubectl get pods
```

Wait until all pods show:

```text
Running
```

---

## Step 7: Verify Services

View services:

```bash
kubectl get svc
```

View ingress:

```bash
kubectl get ingress
```

Access the application using the Load Balancer endpoint.

---

## Local Development Using Docker Compose

Navigate to application directory:

```bash
cd app/opentelemetry-demo
```

Start application:

```bash
docker compose up -d
```

Verify containers:

```bash
docker ps
```

Stop application:

```bash
docker compose down
```

---

## CI/CD Pipeline

GitHub Actions is configured for the Product Catalog microservice and performs:

* Source Code Checkout
* Dependency Installation
* Application Build
* Unit Testing
* Static Code Analysis
* Docker Image Build
* Docker Image Push to Docker Hub
* Kubernetes Manifest Update

---

## Useful Commands

### View Pods

```bash
kubectl get pods
```

### View Services

```bash
kubectl get svc
```

### View Logs

```bash
kubectl logs <pod-name>
```

### Restart Deployment

```bash
kubectl rollout restart deployment <deployment-name>
```

### Delete Application

```bash
kubectl delete -f complete-deploy.yaml
```

---

## Cleanup

Delete Kubernetes resources:

```bash
kubectl delete -f complete-deploy.yaml
```

Destroy infrastructure:

```bash
cd ../terraform

terraform destroy -auto-approve
```

Destroy backend resources:

```bash
cd backend

terraform destroy -auto-approve
```

---

## Future Enhancements

* ArgoCD GitOps Deployment
* Blue/Green Deployments
* Canary Releases
* Prometheus Monitoring
* Grafana Dashboards
* Jaeger Distributed Tracing
* Helm Charts
* Multi-Environment Deployments
* Security Scanning Integration

---

## Author

Vedant Patel

Software Engineering Graduate | AWS | Terraform | Kubernetes | Docker | GitHub Actions | DevOps
