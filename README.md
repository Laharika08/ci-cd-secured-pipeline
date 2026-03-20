# Secure CI/CD Pipeline with DevOps & Security Controls

This project is a hands-on implementation of a **secure CI/CD pipeline** for a FastAPI application.

The idea behind this was simple - instead of treating security as a separate step, I wanted to integrate it directly into the pipeline so that every build goes through proper validation before deployment.

## What this project does

- Builds and tests a FastAPI application
- Runs multiple security checks as part of CI/CD
- Enforces policies before deployment
- Signs container images
- Prepares the application for Kubernetes deployment

## Project Structure

- `app/main.py` → FastAPI application  
- `requirements.txt` → Python dependencies  
- `Dockerfile` → Container build setup  
- `policy/security.rego` → OPA policy (blocks `:latest` tag usage)  
- `config/deployment.yaml` → Kubernetes deployment file  
- `.github/workflows/secure-ci-cd.yml` → CI/CD pipeline  
- `demo_instructions.md` → Steps to run/demo  

## Application Overview

The app itself is intentionally simple — it’s just used to demonstrate the pipeline.

### Endpoints:
- `/` → Health check  
- `/build-info` → Returns:
  - version  
  - build ID  
  - environment  
  - security status  
  - timestamp  

These values are injected at runtime using environment variables.

## Security Controls

This pipeline includes multiple layers of security:

- **Semgrep** → static code analysis (SAST)  
- **Gitleaks** → detects secrets in code  
- **Trivy** → scans dependencies and container images  
- **OPA / Conftest** → validates Kubernetes configs  
- **Cosign** → signs container images  

One important rule I enforced using OPA is blocking the use of `:latest` tags, which helps avoid unpredictable deployments.

##  Requirements

To run this locally:

- Docker  
- kubectl (configured for a cluster)  
- Python 3.10+ (optional)  


## Run Locally

```bash
pip install -r requirements.txt

export APP_VERSION=0.1.0
export BUILD_ID=local
export DEPLOYMENT_ENV=dev
export SECURITY_STATUS=pass
export BUILD_TIMESTAMP=$(date -Iseconds)

uvicorn app.main:app --reload --port 8000
```

## Build & Run with Docker

```bash
docker build -t fastapi-secure-demo:0.1.0 .

docker run --rm -p 8000:8000 \
-e APP_VERSION=0.1.0 \
-e BUILD_ID=$(git rev-parse --short HEAD) \
-e DEPLOYMENT_ENV=local \
-e SECURITY_STATUS=pass \
-e BUILD_TIMESTAMP=$(date -Iseconds) \
fastapi-secure-demo:0.1.0
```


## Kubernetes Deployment

Update the image in:

```
config/deployment.yaml
```

Then apply:

```bash
kubectl apply -f config/deployment.yaml
```

---

## CI/CD Flow

Here’s how the pipeline works:

1. Code is pushed to GitHub  
2. GitHub Actions triggers the workflow  
3. Security scans run (Semgrep, Gitleaks, Trivy)  
4. Policies are validated using OPA  
5. Docker image is built  
6. Image is signed using Cosign  
7. Deployment is prepared for Kubernetes  

## Why I built this

I wanted to understand how real-world pipelines handle **security, automation, and deployment together**, instead of treating them as separate things.

This project helped me get hands-on with:
- integrating security tools into CI/CD  
- enforcing policies before deployment  
- working with container signing and Kubernetes  
