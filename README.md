Outlines how to prebuild, upload to gcr.io and deploy Next.js container on gcloud

```
npx create-next-app@latest
deploy.sh
```

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


  Free tier includes:
  - 2 million requests/month
  - 360,000 GB-seconds memory
  - 180,000 vCPU-seconds
  - 1 GB egress

  Settings to stay free:
  ```
  --max-instances=1 \
  --concurrency=10 \
  --memory=128Mi \
  --cpu=1
```


  - 1 instance × 128MB × 30 days = ~330GB-seconds
  (under 360,000)
  - Low concurrency prevents overloading the single
  instance
  - Still allows ~2,700 requests/hour average

  Hard stop at free tier:
  1. Set up budget alert at $1
  2. Configure action: "Disable billing" when alert
  triggers
  3. Service stops working but you pay $0


