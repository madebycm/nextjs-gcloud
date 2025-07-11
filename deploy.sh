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

echo "🔨 Building Docker image locally..."
docker build --platform linux/amd64 -t ${IMAGE_NAME} .

echo "📤 Pushing image to Container Registry..."
docker push ${IMAGE_NAME}

echo "🚀 Deploying to Cloud Run..."
gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME} \
  --region ${REGION} \
  --project ${PROJECT_ID} \
  --platform managed \
  --allow-unauthenticated

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