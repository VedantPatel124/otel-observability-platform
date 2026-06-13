# OpenTelemetry Observability Platform on AWS EKS

## Project Overview

This project demonstrates the deployment of a cloud-native microservices application on Amazon EKS using Infrastructure as Code, Kubernetes, CI/CD automation, and AWS-native networking components.

The application is based on the OpenTelemetry Demo microservices architecture and is deployed using a production-style DevOps workflow.

## Key Features

* Infrastructure provisioning using Terraform
* Amazon EKS cluster deployment
* Kubernetes-based microservices orchestration
* GitHub Actions CI/CD pipeline
* AWS Load Balancer Controller integration
* Kubernetes Ingress for external access
* Docker-based containerized services
* EC2 management/bastion host for cluster operations
* OpenTelemetry Demo microservices deployment

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
Amazon ECR / Container Images
        │
        ▼
Terraform
        │
        ▼
Amazon EKS
        │
        ▼
Kubernetes Cluster
        │
        ▼
OpenTelemetry Demo
        │
        ▼
AWS Load Balancer Controller
        │
        ▼
Application Load Balancer (ALB)
        │
        ▼
End Users
```

---

## Technology Stack

### Cloud

* AWS EC2
* AWS EKS
* AWS VPC
* AWS IAM
* AWS S3
* AWS Route 53 (Optional)

### Infrastructure as Code

* Terraform

### Containerization

* Docker
* Docker Compose

### Container Orchestration

* Kubernetes

### CI/CD

* GitHub Actions

### Languages

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
│       └── Makefile
│
├── README.md
├── .gitignore
└── .dockerignore
```

---

## Prerequisites

Install the following tools on your EC2 management instance or local machine:

* AWS CLI
* Terraform
* kubectl
* Docker
* Git
* Helm
* eksctl

Verify installation:

```bash
aws --version
terraform --version
kubectl version --client
docker --version
helm version
eksctl version
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

Verify:

```bash
aws sts get-caller-identity
```

---

## Step 3: Create Terraform Backend

```bash
cd terraform/backend

terraform init

terraform apply -auto-approve
```

This creates:

* S3 Bucket for Terraform State
* DynamoDB Lock Table

---

## Step 4: Provision Infrastructure

```bash
cd ..

terraform init

terraform plan

terraform apply -auto-approve
```

Resources Created:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* EKS Cluster
* Managed Node Group

---

## Step 5: Configure kubectl

```bash
aws eks update-kubeconfig \
--region us-east-1 \
--name demo-eks-cluster
```

Verify:

```bash
kubectl get nodes
```

---

## Step 6: Deploy OpenTelemetry Application

```bash
cd ../kubernetes

kubectl apply -f complete-deploy.yaml
```

Verify:

```bash
kubectl get pods

kubectl get svc
```

---

## Step 7: Configure AWS Load Balancer Controller

Associate OIDC Provider:

```bash
eksctl utils associate-iam-oidc-provider \
--cluster demo-eks-cluster \
--approve
```

Create IAM Policy:

```bash
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
```

Create IAM Service Account:

```bash
eksctl create iamserviceaccount \
--cluster=demo-eks-cluster \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--role-name=AmazonEKSLoadBalancerControllerRole \
--attach-policy-arn=<IAM_POLICY_ARN> \
--approve
```

Install AWS Load Balancer Controller:

```bash
helm repo add eks https://aws.github.io/eks-charts

helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
-n kube-system \
--set clusterName=demo-eks-cluster \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller \
--set region=us-east-1 \
--set vpcId=<VPC_ID>
```

Verify:

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
```

---

## Step 8: Deploy Ingress

```bash
kubectl apply -f frontendproxy/ingress.yaml
```

Verify:

```bash
kubectl get ingress
```

After a few minutes, an AWS Application Load Balancer will be provisioned automatically.

---

## Step 9: Access the Application

Retrieve the ALB DNS name:

```bash
kubectl get ingress
```

Open:

```text
http://<ALB-DNS-NAME>
```

---

## Useful Commands

### Nodes

```bash
kubectl get nodes
```

### Pods

```bash
kubectl get pods -A
```

### Services

```bash
kubectl get svc
```

### Ingress

```bash
kubectl get ingress
```

### Logs

```bash
kubectl logs <pod-name>
```

### Restart Deployment

```bash
kubectl rollout restart deployment <deployment-name>
```

---

## Cleanup

Delete Application:

```bash
kubectl delete -f kubernetes/complete-deploy.yaml
```

Remove ALB Controller:

```bash
helm uninstall aws-load-balancer-controller -n kube-system
```

Destroy Infrastructure:

```bash
cd terraform

terraform destroy -auto-approve
```

Destroy Backend:

```bash
cd backend

terraform destroy -auto-approve
```

---

## Future Enhancements

* Route 53 Custom Domain
* ACM SSL Certificates
* ArgoCD GitOps
* Prometheus Monitoring
* Grafana Dashboards
* Helm-based Deployments
* Multi-Environment Support
* Blue-Green Deployments
* Canary Releases

---

## Author

Vedant Patel

Software Engineering Graduate | AWS | Terraform | Kubernetes | DevOps | Cloud Infrastructure
