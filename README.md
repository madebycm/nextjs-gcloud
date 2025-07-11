Outlines how to prebuild, upload to gcr.io and deploy Next.js container on gcloud

`npx create-next-app@latest`
`deploy.sh`

Set config vars + resource limits in main deploy entrypoint:
```
# Configuration
PROJECT_ID="madebycm-omegaproject"
SERVICE_NAME="helloworld"
REGION="us-east1"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

# Resource limits
MEMORY="1Gi"
CPU="1"
MAX_INSTANCES="10"
```
