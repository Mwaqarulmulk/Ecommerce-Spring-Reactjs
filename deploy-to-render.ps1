# Render Deployment Script
# Quick deployment using Render API

$RENDER_API_KEY = "rnd_dDmVRQFB82oTLl56P8aa8ZG6yrpU"
$GITHUB_REPO = "ghulam-mujtaba5/Ecommerce-Spring-Reactjs"

Write-Host "=" -ForegroundColor Cyan
Write-Host "🚀 RENDER DEPLOYMENT STARTED" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to create service
function Create-RenderService {
    param(
        [string]$serviceJson
    )
    
    $headers = @{
        "Authorization" = "Bearer $RENDER_API_KEY"
        "Content-Type" = "application/json"
    }
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.render.com/v1/services" -Method Post -Headers $headers -Body $serviceJson
        return $response
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
        return $null
    }
}

# Step 1: Create PostgreSQL Database
Write-Host "📦 Step 1: Creating PostgreSQL Database..." -ForegroundColor Yellow

$dbConfig = @{
    type = "pserv"
    name = "ecommerce-db-$(Get-Date -Format 'MMddHHmm')"
    ownerId = ""
    plan = "free"
    region = "oregon"
    databaseName = "ecommerce"
    databaseUser = "ecomuser"
    ipAllowList = @()
} | ConvertTo-Json -Depth 10

Write-Host "Creating database..." -ForegroundColor Cyan
$dbResponse = Create-RenderService -serviceJson $dbConfig

if ($dbResponse) {
    Write-Host "✅ Database created successfully!" -ForegroundColor Green
    Write-Host "   Database ID: $($dbResponse.service.id)" -ForegroundColor Gray
    $dbId = $dbResponse.service.id
} else {
    Write-Host "❌ Database creation failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "MANUAL DEPLOYMENT REQUIRED:" -ForegroundColor Yellow
    Write-Host "Please go to: https://dashboard.render.com/new/database" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "⏳ Waiting for database to be ready (60 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Step 2: Create Backend Web Service
Write-Host "📦 Step 2: Creating Backend Service..." -ForegroundColor Yellow

$backendConfig = @{
    type = "web_service"
    name = "ecommerce-backend-$(Get-Date -Format 'MMddHHmm')"
    ownerId = ""
    repo = "https://github.com/$GITHUB_REPO"
    autoDeploy = "yes"
    branch = "master"
    dockerfilePath = "ecom-backend/Dockerfile"
    dockerCommand = ""
    buildFilter = @{
        paths = @("ecom-backend/**")
    }
    envVars = @(
        @{ key = "SERVER_PORT"; value = "10000" }
        @{ key = "SPRING_PROFILES_ACTIVE"; value = "prod" }
        @{ key = "SPRING_JPA_HIBERNATE_DDL_AUTO"; value = "update" }
    )
    region = "oregon"
    plan = "free"
    healthCheckPath = "/actuator/health"
} | ConvertTo-Json -Depth 10

Write-Host "Creating backend service..." -ForegroundColor Cyan
$backendResponse = Create-RenderService -serviceJson $backendConfig

if ($backendResponse) {
    Write-Host "✅ Backend service created successfully!" -ForegroundColor Green
    $backendUrl = $backendResponse.service.serviceDetails.url
    Write-Host "   Backend URL: https://$backendUrl" -ForegroundColor Cyan
} else {
    Write-Host "❌ Backend creation failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "⏳ Waiting for backend build to start (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Step 3: Create Frontend Static Site
Write-Host "📦 Step 3: Creating Frontend Service..." -ForegroundColor Yellow

$frontendConfig = @{
    type = "static_site"
    name = "ecommerce-frontend-$(Get-Date -Format 'MMddHHmm')"
    ownerId = ""
    repo = "https://github.com/$GITHUB_REPO"
    autoDeploy = "yes"
    branch = "master"
    rootDir = "ecom-frontend"
    buildCommand = "npm install && npm run build"
    publishPath = "dist"
    pullRequestPreviewsEnabled = "no"
    envVars = @(
        @{ key = "VITE_API_URL"; value = "https://$backendUrl" }
    )
    region = "oregon"
} | ConvertTo-Json -Depth 10

Write-Host "Creating frontend service..." -ForegroundColor Cyan
$frontendResponse = Create-RenderService -serviceJson $frontendConfig

if ($frontendResponse) {
    Write-Host "✅ Frontend service created successfully!" -ForegroundColor Green
    $frontendUrl = $frontendResponse.service.serviceDetails.url
    Write-Host "   Frontend URL: https://$frontendUrl" -ForegroundColor Cyan
} else {
    Write-Host "❌ Frontend creation failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🎉 DEPLOYMENT INITIATED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 YOUR SERVICES:" -ForegroundColor Yellow
Write-Host "   🗄️  Database: Created (Internal only)" -ForegroundColor Gray
Write-Host "   🚀 Backend:  https://$backendUrl" -ForegroundColor Cyan
Write-Host "   🎨 Frontend: https://$frontendUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "⏰ Build Times (Estimated):" -ForegroundColor Yellow
Write-Host "   Backend:  5-8 minutes" -ForegroundColor Gray
Write-Host "   Frontend: 2-3 minutes" -ForegroundColor Gray
Write-Host ""
Write-Host "📊 Monitor Progress:" -ForegroundColor Yellow
Write-Host "   Dashboard: https://dashboard.render.com" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Wait 5-10 minutes for builds to complete" -ForegroundColor Gray
Write-Host "   2. Visit frontend URL to test application" -ForegroundColor Gray
Write-Host "   3. Take screenshots for submission" -ForegroundColor Gray
Write-Host "   4. Add URLs to README.md" -ForegroundColor Gray
Write-Host ""
