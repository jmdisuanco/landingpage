#!/bin/bash
set -e

APP_NAME="landingpage"
DOKKU_HOST="192.168.0.128"
DOMAIN="landingpage.jmart.digital"

echo "🚀 Deploying landingpage to Dokku"

# Initialize git if not already done
if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial commit for deployment"
fi

# Add dokku remote
if git remote get-url dokku >/dev/null 2>&1; then
    git remote set-url dokku "dokku@${DOKKU_HOST}:${APP_NAME}"
else
    git remote add dokku "dokku@${DOKKU_HOST}:${APP_NAME}"
fi

# Create app on Dokku if it doesn't exist
ssh -o StrictHostKeyChecking=no "dokku@${DOKKU_HOST}" "apps:create ${APP_NAME}" 2>/dev/null || true

# Set domain
ssh -o StrictHostKeyChecking=no "dokku@${DOKKU_HOST}" "domains:set ${APP_NAME} ${DOMAIN}"

# Deploy
git push dokku main --force

echo "✅ Deployment complete!"
echo "🌐 Your app is available at: https://${DOMAIN}"
