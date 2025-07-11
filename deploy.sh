#!/bin/bash
# @author madebycm (2025)
# Deploy script for Cloud Run using local Docker build

# Prerequisites:
# 1. Install gcloud CLI: https://cloud.google.com/sdk/docs/install
# 2. Install Docker: https://docs.docker.com/get-docker/
# 3. Authenticate: gcloud auth login
# 4. Set project: gcloud config set project madebycm-aidaw4
# 5. Enable APIs: gcloud services enable run.googleapis.com containerregistry.googleapis.com
# 6. Configure Docker: gcloud auth configure-docker

set -e

# Configuration
PROJECT_ID="madebycm-nextjs"
SERVICE_NAME="helloworld"
REGION="us-east1"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

# Resource limits
MEMORY="1Gi"
CPU="1"
MAX_INSTANCES="10"

# Local dev mode
if [ "$1" == "dev" ]; then
  echo "🔨 Building Docker image for local development..."
  DOCKER_BUILDKIT=1 docker build -t ${SERVICE_NAME}-dev .

  echo "🏃 Running container locally on port 8080..."
  echo "Container will be accessible at http://localhost:8080"
  echo "Press Ctrl+C to stop"

  docker run --rm -p 8080:8080 ${SERVICE_NAME}-dev
  exit 0
fi

echo "🔨 Building Docker image locally with BuildKit..."
DOCKER_BUILDKIT=1 docker build --platform linux/amd64 -t ${IMAGE_NAME} .

echo "📤 Pushing image to Container Registry..."
docker push ${IMAGE_NAME}

echo "🚀 Deploying to Cloud Run..."
gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --region ${REGION} \
  --project ${PROJECT_ID} \
  --platform managed \
  --allow-unauthenticated \
  --memory ${MEMORY} \
  --cpu ${CPU} \
  --max-instances ${MAX_INSTANCES}

echo "✅ Deployment complete!"

# First time setup help
if [ "$1" == "setup" ]; then
  echo ""
  echo "Running first-time setup..."
  gcloud auth login
  gcloud config set project ${PROJECT_ID}
  gcloud services enable run.googleapis.com containerregistry.googleapis.com
  gcloud auth configure-docker
  echo "Setup complete! Run ./deploy.sh again to deploy."
fi
