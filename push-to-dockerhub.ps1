# Quick Docker Hub Push Script
# This builds and pushes images directly to Docker Hub

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🐳 DOCKER HUB DEPLOYMENT SCRIPT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Prompt for Docker Hub credentials
Write-Host "📝 Enter your Docker Hub credentials:" -ForegroundColor Yellow
Write-Host ""
$DOCKERHUB_USERNAME = Read-Host "Docker Hub Username"

if ([string]::IsNullOrWhiteSpace($DOCKERHUB_USERNAME)) {
    Write-Host "❌ Username is required!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔐 Logging in to Docker Hub..." -ForegroundColor Yellow
Write-Host "Enter password when prompted:" -ForegroundColor Gray
docker login -u $DOCKERHUB_USERNAME

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker Hub login failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Login successful!" -ForegroundColor Green
Write-Host ""

# Image names
$BACKEND_IMAGE = "$DOCKERHUB_USERNAME/ecom-backend"
$FRONTEND_IMAGE = "$DOCKERHUB_USERNAME/ecom-frontend"
$TIMESTAMP = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📦 Building Backend Image..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Build backend
docker build -t ${BACKEND_IMAGE}:latest -t ${BACKEND_IMAGE}:${TIMESTAMP} -f ecom-backend/Dockerfile .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Backend image built successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📦 Building Frontend Image..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Build frontend
docker build -t ${FRONTEND_IMAGE}:latest -t ${FRONTEND_IMAGE}:${TIMESTAMP} -f ecom-frontend/Dockerfile .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Frontend image built successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 Pushing Backend Image to Docker Hub..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Push backend
docker push ${BACKEND_IMAGE}:latest
docker push ${BACKEND_IMAGE}:${TIMESTAMP}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend push failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Backend image pushed successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 Pushing Frontend Image to Docker Hub..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Push frontend
docker push ${FRONTEND_IMAGE}:latest
docker push ${FRONTEND_IMAGE}:${TIMESTAMP}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend push failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Frontend image pushed successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📦 Images pushed:" -ForegroundColor Yellow
Write-Host "   🔹 ${BACKEND_IMAGE}:latest" -ForegroundColor Cyan
Write-Host "   🔹 ${BACKEND_IMAGE}:${TIMESTAMP}" -ForegroundColor Cyan
Write-Host "   🔹 ${FRONTEND_IMAGE}:latest" -ForegroundColor Cyan
Write-Host "   🔹 ${FRONTEND_IMAGE}:${TIMESTAMP}" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 View on Docker Hub:" -ForegroundColor Yellow
Write-Host "   https://hub.docker.com/u/${DOCKERHUB_USERNAME}" -ForegroundColor Cyan
Write-Host ""
Write-Host "📸 Next Step: Take screenshot of Docker Hub!" -ForegroundColor Green
Write-Host ""
