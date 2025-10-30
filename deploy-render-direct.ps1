# RENDER DEPLOYMENT - Direct Service Creation
# Creates services one by one using Render API

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 DEPLOYING TO RENDER (Direct API)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$RENDER_API_KEY = "rnd_dDmVRQFB82oTLl56P8aa8ZG6yrpU"
$OWNER_ID = "tea-d41ftca4d50c73eo49r0"
$GITHUB_REPO = "ghulam-mujtaba5/Ecommerce-Spring-Reactjs"
$BRANCH = "master"

$headers = @{
    "Authorization" = "Bearer $RENDER_API_KEY"
    "Content-Type" = "application/json"
}

# Step 1: Create PostgreSQL Database
Write-Host "📦 Step 1/3: Creating PostgreSQL Database..." -ForegroundColor Yellow

$dbPayload = @{
    name = "ecommerce-db"
    ownerId = $OWNER_ID
    region = "oregon"
    plan = "free"
    databaseName = "ecommerce"
    databaseUser = "ecomuser"
    version = "15"
} | ConvertTo-Json

try {
    $dbResponse = Invoke-RestMethod -Uri "https://api.render.com/v1/postgres" `
        -Method Post `
        -Headers $headers `
        -Body $dbPayload `
        -ErrorAction Stop
    
    $dbId = $dbResponse.id
    Write-Host "   ✅ Database created!" -ForegroundColor Green
    Write-Host "   Database ID: $dbId" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   ⏳ Waiting 60 seconds for database..." -ForegroundColor Yellow
    Start-Sleep -Seconds 60
    
    # Get database connection info
    $dbDetails = Invoke-RestMethod -Uri "https://api.render.com/v1/postgres/$dbId" `
        -Method Get `
        -Headers $headers
    
    $dbUrl = $dbDetails.connectionInfo.internalConnectionString
    Write-Host "   ✅ Database ready!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "   ❌ Database creation failed: $_" -ForegroundColor Red
    $dbId = "manual"
    $dbUrl = "postgresql://ecomuser:password@host/ecommerce"
}

# Step 2: Create Backend Web Service
Write-Host "📦 Step 2/3: Creating Backend Service..." -ForegroundColor Yellow

$backendPayload = @{
    name = "ecommerce-backend-$(Get-Date -Format 'MMddHHmm')"
    ownerId = $OWNER_ID
    type = "web_service"
    serviceDetails = @{
        env = "docker"
        envVars = @(
            @{ key = "SPRING_DATASOURCE_URL"; value = $dbUrl },
            @{ key = "SPRING_DATASOURCE_USERNAME"; value = "ecomuser" },
            @{ key = "SPRING_DATASOURCE_PASSWORD"; value = "changeme" },
            @{ key = "SERVER_PORT"; value = "10000" },
            @{ key = "SPRING_PROFILES_ACTIVE"; value = "prod" },
            @{ key = "SPRING_JPA_HIBERNATE_DDL_AUTO"; value = "update" }
        )
        healthCheckPath = "/actuator/health"
        dockerfilePath = "ecom-backend/Dockerfile"
        region = "oregon"
        plan = "free"
        branch = $BRANCH
        repo = "https://github.com/$GITHUB_REPO"
    }
} | ConvertTo-Json -Depth 10

try {
    $backendResponse = Invoke-RestMethod -Uri "https://api.render.com/v1/services" `
        -Method Post `
        -Headers $headers `
        -Body $backendPayload `
        -ErrorAction Stop
    
    $backendId = $backendResponse.service.id
    $backendUrl = "https://$($backendResponse.service.serviceDetails.url)"
    Write-Host "   ✅ Backend service created!" -ForegroundColor Green
    Write-Host "   Service ID: $backendId" -ForegroundColor Gray
    Write-Host "   URL: $backendUrl" -ForegroundColor Cyan
    Write-Host ""
} catch {
    Write-Host "   ❌ Backend creation failed: $_" -ForegroundColor Red
    $backendId = "manual"
    $backendUrl = "https://ecommerce-backend.onrender.com"
}

# Step 3: Create Frontend Static Site
Write-Host "📦 Step 3/3: Creating Frontend Service..." -ForegroundColor Yellow

$frontendPayload = @{
    name = "ecommerce-frontend-$(Get-Date -Format 'MMddHHmm')"
    ownerId = $OWNER_ID
    type = "static_site"
    serviceDetails = @{
        buildCommand = "cd ecom-frontend && npm install && npm run build"
        publishPath = "ecom-frontend/dist"
        envVars = @(
            @{ key = "VITE_API_URL"; value = $backendUrl }
        )
        branch = $BRANCH
        repo = "https://github.com/$GITHUB_REPO"
        pullRequestPreviewsEnabled = "no"
    }
} | ConvertTo-Json -Depth 10

try {
    $frontendResponse = Invoke-RestMethod -Uri "https://api.render.com/v1/services" `
        -Method Post `
        -Headers $headers `
        -Body $frontendPayload `
        -ErrorAction Stop
    
    $frontendId = $frontendResponse.service.id
    $frontendUrl = "https://$($frontendResponse.service.serviceDetails.url)"
    Write-Host "   ✅ Frontend service created!" -ForegroundColor Green
    Write-Host "   Service ID: $frontendId" -ForegroundColor Gray
    Write-Host "   URL: $frontendUrl" -ForegroundColor Cyan
    Write-Host ""
} catch {
    Write-Host "   ❌ Frontend creation failed: $_" -ForegroundColor Red
    $frontendId = "manual"
    $frontendUrl = "https://ecommerce-frontend.onrender.com"
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ DEPLOYMENT STATUS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Database ID: $dbId" -ForegroundColor Gray
Write-Host "Backend ID: $backendId" -ForegroundColor Gray
Write-Host "Frontend ID: $frontendId" -ForegroundColor Gray
Write-Host ""
Write-Host "Backend URL: $backendUrl" -ForegroundColor Cyan
Write-Host "Frontend URL: $frontendUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "Dashboard: https://dashboard.render.com" -ForegroundColor Cyan
Write-Host ""

Start-Process "https://dashboard.render.com"
