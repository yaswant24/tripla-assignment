# Terraform-Parse – Tripla SRE Technical Assignment

##  Overview

This repository contains the solution for the Tripla SRE take-home assignment.

The project includes:

* Terraform infrastructure (EKS + S3)
* Terraform Parse backend service (API → Terraform file generator)
* Helm chart deployment (Kubernetes)
* Dockerized backend service

---

## 📁 Project Structure

```
terraform-parse/
│
├── terraform/                 # Infrastructure (EKS + S3)
├── helm/                      # Helm chart for Kubernetes deployment
├── terraform_parse_service/   # Backend API service
├── README.md
└── NOTES.md
```

---

##  Prerequisites

Make sure the following tools are installed:

* AWS CLI
* Terraform (>= 1.5)
* Docker
* kubectl
* Helm
* Access to an AWS EKS cluster

---

## Terraform (Infrastructure)

### Initialize Terraform

```bash
cd terraform
terraform init
```

### Validate

```bash
terraform fmt -recursive
terraform validate
```

### Plan

```bash
terraform plan -var-file=envs/dev.tfvars
```

### Apply

```bash
terraform apply -var-file=envs/dev.tfvars
```

---

## Terraform Parse Service

The backend service accepts a POST API request and generates a Terraform `.tf` file for S3 bucket creation.

### Build Docker Image

```bash
cd terraform_parse_service
docker build -t terraform-parse-service .
```

### Run Container

```bash
docker run -d -p 8080:8080 --name tf-parser terraform-parse-service
```

---

## API Testing

### Health Check

```bash
curl localhost:8080/health
```

Expected output:

```json
{"status":"ok"}
```

---

### Generate Terraform File

```bash
curl -X POST http://localhost:8080/generate \
-H "Content-Type: application/json" \
-d '{
  "payload":{
    "properties":{
      "aws_region":"eu-west-1",
      "acl":"private",
      "bucket_name":"tripla-bucket"
    }
  }
}'
```

Generated file location:

```
output/generated.tf
```

---

## Helm Deployment (Kubernetes)

### Lint Chart

```bash
cd helm
helm lint .
```

### Dry Run

```bash
helm install tripla . --dry-run --debug
```

### Deploy

```bash
helm install tripla .
```

### Upgrade (if already installed)

```bash
helm upgrade tripla .
```

---

## Verify Deployment

```bash
kubectl get pods
kubectl get svc
```

---

## Test of Backend Service on Kubernetes

Port forward backend service:

```bash
kubectl port-forward svc/backend-svc 8080:8080
```

Then test:

```bash
curl localhost:8080/health
```

---

## Cleanup

```bash
helm uninstall tripla
```

---


