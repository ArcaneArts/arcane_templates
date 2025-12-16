#!/bin/bash
#
# Deploy arcane_cli_app Server to Google Cloud Run
#
# Prerequisites:
# 1. Google Cloud CLI installed and configured
# 2. Docker installed
# 3. Artifact Registry repository created
# 4. Proper permissions set up
#

set -e  # Exit on error

PROJECT_ID="FIREBASE_PROJECT_ID"
REGION="us-central1"
REGISTRY_NAME="cloud-run-source-deploy"
SERVICE_NAME="arcane_cli_app-server"

echo "Building arcane_cli_app Server for deployment..."

# Copy models directory for Docker build context
echo "Copying models directory..."
cp -r ../arcane_models arcane_models

# Get dependencies
flutter pub get
cd arcane_models && flutter pub get && rm -rf .dart_tool && cd ..

# Build Docker image
echo "Building Docker image..."
docker build --platform linux/amd64 \
  -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REGISTRY_NAME}/${SERVICE_NAME}:latest .

# Clean up temporary models directory
rm -rf arcane_models

# Push to Artifact Registry
echo "Pushing image to Artifact Registry..."
docker push --platform linux/amd64 \
  ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REGISTRY_NAME}/${SERVICE_NAME}:latest

# Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud beta run deploy ${SERVICE_NAME} \
  --region=${REGION} \
  --project=${PROJECT_ID} \
  --image=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REGISTRY_NAME}/${SERVICE_NAME}:latest \
  --min-instances=0 \
  --memory=1Gi \
  --cpu=1 \
  --concurrency=10 \
  --cpu-boost \
  --timeout=3600s

echo "Deployment complete!"
echo "Service URL: https://${SERVICE_NAME}-[PROJECT-HASH].${REGION}.run.app"
