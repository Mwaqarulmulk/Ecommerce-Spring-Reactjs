# Fully Automated Docker Login and Push
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🐳 AUTOMATED DOCKER HUB DEPLOYMENT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Your Docker Hub credentials
$username = "mujtaba0101"
$password = "rnd_dDmVRQFB82oTLl56P8aa8ZG6yrpU"

Write-Host "🔐 Logging in to Docker Hub..." -ForegroundColor Yellow

# Create a temporary file with the password
$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value $password -NoNewline

# Use the temp file for login
Get-Content $tempFile | docker login --username $username --password-stdin

# Clean up temp file
Remove-Item $tempFile -ErrorAction SilentlyContinue

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker Hub login failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Login successful!" -ForegroundColor Green
Write-Host ""

# Image names
$BACKEND_IMAGE = "${username}/ecom-backend"
$FRONTEND_IMAGE = "${username}/ecom-frontend"
$TIMESTAMP = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📦 Building Backend Image..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

docker build -t ${BACKEND_IMAGE}:latest -t ${BACKEND_IMAGE}:${TIMESTAMP} -f ecom-backend/Dockerfile .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Backend image built!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📦 Building Frontend Image..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

docker build -t ${FRONTEND_IMAGE}:latest -t ${FRONTEND_IMAGE}:${TIMESTAMP} -f ecom-frontend/Dockerfile .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Frontend image built!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 Pushing Backend to Docker Hub..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

docker push ${BACKEND_IMAGE}:latest
docker push ${BACKEND_IMAGE}:${TIMESTAMP}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend push failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Backend pushed!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 Pushing Frontend to Docker Hub..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

docker push ${FRONTEND_IMAGE}:latest
docker push ${FRONTEND_IMAGE}:${TIMESTAMP}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend push failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Frontend pushed!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Your images:" -ForegroundColor Yellow
Write-Host "   Backend:  ${BACKEND_IMAGE}:latest" -ForegroundColor White
Write-Host "   Frontend: ${FRONTEND_IMAGE}:latest" -ForegroundColor White
Write-Host ""
Write-Host "🌐 View at: https://hub.docker.com/u/${username}" -ForegroundColor Cyan
Write-Host ""
