# Fully Automated Docker Hub Push Script
# No manual password entry required!

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🐳 AUTOMATED DOCKER HUB DEPLOYMENT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Docker Hub credentials
$DOCKERHUB_USERNAME = "mujtaba0101"
$DOCKERHUB_TOKEN = "rnd_dDmVRQFB82oTLl56P8aa8ZG6yrpU"

Write-Host "🔐 Logging in to Docker Hub automatically..." -ForegroundColor Yellow

# Automated login using token - use echo instead of pipe for better compatibility
echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USERNAME --password-stdin

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker Hub login failed!" -ForegroundColor Red
    Write-Host "Please verify your username and token." -ForegroundColor Yellow
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
Write-Host "📝 Your images are now available at:" -ForegroundColor Yellow
Write-Host "   Backend:  ${BACKEND_IMAGE}:latest" -ForegroundColor White
Write-Host "   Frontend: ${FRONTEND_IMAGE}:latest" -ForegroundColor White
Write-Host ""
Write-Host "🌐 View on Docker Hub:" -ForegroundColor Yellow
Write-Host "   https://hub.docker.com/u/${DOCKERHUB_USERNAME}" -ForegroundColor Cyan
Write-Host ""
