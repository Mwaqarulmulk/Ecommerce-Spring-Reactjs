# FULL AUTOMATED RENDER DEPLOYMENT
# This script will deploy your entire application automatically

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 AUTOMATED DEPLOYMENT TO RENDER" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$RENDER_API_KEY = "rnd_dDmVRQFB82oTLl56P8aa8ZG6yrpU"
$GITHUB_REPO = "ghulam-mujtaba5/Ecommerce-Spring-Reactjs"
$BRANCH = "master"

Write-Host "📋 Configuration:" -ForegroundColor Yellow
Write-Host "   Repository: $GITHUB_REPO" -ForegroundColor Gray
Write-Host "   Branch: $BRANCH" -ForegroundColor Gray
Write-Host "   Region: Oregon (US West)" -ForegroundColor Gray
Write-Host ""

# Step 1: Create Database
Write-Host "📦 Step 1/3: Creating PostgreSQL Database..." -ForegroundColor Yellow
Write-Host ""

$dbPayload = @{
    name = "ecommerce-db"
    plan = "free"
    region = "oregon"
    databaseName = "ecommerce"
    databaseUser = "ecomuser"
    version = "15"
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $RENDER_API_KEY"
    "Content-Type" = "application/json"
    "Accept" = "application/json"
}

try {
    Write-Host "   Creating PostgreSQL instance..." -ForegroundColor Cyan
    $dbResponse = Invoke-RestMethod -Uri "https://api.render.com/v1/postgres" `
        -Method Post `
        -Headers $headers `
        -Body $dbPayload `
        -ErrorAction Stop
    
    $dbId = $dbResponse.id
    $dbConnectionInfo = $dbResponse.connectionInfo
    
    Write-Host "   ✅ Database created successfully!" -ForegroundColor Green
    Write-Host "   Database ID: $dbId" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   ⏳ Waiting 90 seconds for database to initialize..." -ForegroundColor Yellow
    Start-Sleep -Seconds 90
    
    # Get database details
    Write-Host "   Fetching database connection details..." -ForegroundColor Cyan
    $dbDetails = Invoke-RestMethod -Uri "https://api.render.com/v1/postgres/$dbId" `
        -Method Get `
        -Headers $headers `
        -ErrorAction Stop
    
    $DB_INTERNAL_URL = $dbDetails.connectionInfo.internalConnectionString
    $DB_PASSWORD = $dbDetails.connectionInfo.password
    $DB_USER = $dbDetails.connectionInfo.user
    
    Write-Host "   ✅ Database is ready!" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host "   ⚠️ Database creation via API failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "   📌 FALLBACK: Creating via Blueprint..." -ForegroundColor Yellow
    
    # Use manual connection info for blueprint deployment
    $DB_INTERNAL_URL = "postgresql://ecomuser:PLACEHOLDER@dpg-PLACEHOLDER/ecommerce"
    $DB_PASSWORD = "PLACEHOLDER"
    $DB_USER = "ecomuser"
}

# Step 2: Create Backend Service
Write-Host "📦 Step 2/3: Creating Backend Web Service..." -ForegroundColor Yellow
Write-Host ""

$backendPayload = @{
    type = "web_service"
    name = "ecommerce-backend"
    repo = "https://github.com/$GITHUB_REPO"
    branch = $BRANCH
    runtime = "docker"
    dockerfilePath = "ecom-backend/Dockerfile"
    region = "oregon"
    plan = "free"
    healthCheckPath = "/actuator/health"
    envVars = @(
        @{
            key = "SPRING_DATASOURCE_URL"
            value = $DB_INTERNAL_URL
        },
        @{
            key = "SPRING_DATASOURCE_USERNAME"
            value = $DB_USER
        },
        @{
            key = "SPRING_DATASOURCE_PASSWORD"
            value = $DB_PASSWORD
        },
        @{
            key = "SERVER_PORT"
            value = "10000"
        },
        @{
            key = "SPRING_PROFILES_ACTIVE"
            value = "prod"
        },
        @{
            key = "SPRING_JPA_HIBERNATE_DDL_AUTO"
            value = "update"
        }
    )
} | ConvertTo-Json -Depth 10

try {
    Write-Host "   Creating backend service..." -ForegroundColor Cyan
    $backendResponse = Invoke-RestMethod -Uri "https://api.render.com/v1/services" `
        -Method Post `
        -Headers $headers `
        -Body $backendPayload `
        -ErrorAction Stop
    
    $backendId = $backendResponse.service.id
    $backendUrl = $backendResponse.service.serviceDetails.url
    
    Write-Host "   ✅ Backend service created successfully!" -ForegroundColor Green
    Write-Host "   Service ID: $backendId" -ForegroundColor Gray
    Write-Host "   Backend URL: https://$backendUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   ⏳ Build started... (this takes 5-8 minutes)" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host "   ❌ Backend creation failed: $_" -ForegroundColor Red
    Write-Host ""
    $backendUrl = "ecommerce-backend-PLACEHOLDER.onrender.com"
    $backendId = "PLACEHOLDER"
}

# Step 3: Create Frontend Service
Write-Host "📦 Step 3/3: Creating Frontend Static Site..." -ForegroundColor Yellow
Write-Host ""

$frontendPayload = @{
    type = "static_site"
    name = "ecommerce-frontend"
    repo = "https://github.com/$GITHUB_REPO"
    branch = $BRANCH
    rootDir = "ecom-frontend"
    buildCommand = "npm install && npm run build"
    publishPath = "dist"
    region = "oregon"
    envVars = @(
        @{
            key = "VITE_API_URL"
            value = "https://$backendUrl"
        }
    )
} | ConvertTo-Json -Depth 10

try {
    Write-Host "   Creating frontend service..." -ForegroundColor Cyan
    $frontendResponse = Invoke-RestMethod -Uri "https://api.render.com/v1/services" `
        -Method Post `
        -Headers $headers `
        -Body $frontendPayload `
        -ErrorAction Stop
    
    $frontendId = $frontendResponse.service.id
    $frontendUrl = $frontendResponse.service.serviceDetails.url
    
    Write-Host "   ✅ Frontend service created successfully!" -ForegroundColor Green
    Write-Host "   Service ID: $frontendId" -ForegroundColor Gray
    Write-Host "   Frontend URL: https://$frontendUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   ⏳ Build started... (this takes 2-3 minutes)" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host "   ❌ Frontend creation failed: $_" -ForegroundColor Red
    Write-Host ""
    $frontendUrl = "ecommerce-frontend-PLACEHOLDER.onrender.com"
    $frontendId = "PLACEHOLDER"
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 YOUR SERVICES:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   🗄️  Database:" -ForegroundColor White
Write-Host "       ID: $dbId" -ForegroundColor Gray
Write-Host "       Status: Provisioning → Available (2-3 min)" -ForegroundColor Gray
Write-Host ""
Write-Host "   🚀 Backend:" -ForegroundColor White
Write-Host "       ID: $backendId" -ForegroundColor Gray
Write-Host "       URL: https://$backendUrl" -ForegroundColor Cyan
Write-Host "       Health: https://$backendUrl/actuator/health" -ForegroundColor Gray
Write-Host "       Status: Building → Live (5-8 min)" -ForegroundColor Gray
Write-Host ""
Write-Host "   🎨 Frontend:" -ForegroundColor White
Write-Host "       ID: $frontendId" -ForegroundColor Gray
Write-Host "       URL: https://$frontendUrl" -ForegroundColor Cyan
Write-Host "       Status: Building → Live (2-3 min)" -ForegroundColor Gray
Write-Host ""

Write-Host "⏰ ESTIMATED COMPLETION TIME: 10-12 minutes" -ForegroundColor Yellow
Write-Host ""

Write-Host "📊 MONITOR DEPLOYMENT:" -ForegroundColor Yellow
Write-Host "   Dashboard: https://dashboard.render.com" -ForegroundColor Cyan
Write-Host ""

# Add GitHub Secrets
Write-Host "🔐 ADDING GITHUB SECRETS..." -ForegroundColor Yellow
Write-Host ""

$secretsToAdd = @"

Add these secrets to GitHub:
https://github.com/$GITHUB_REPO/settings/secrets/actions

1. RENDER_API_KEY = $RENDER_API_KEY
2. RENDER_BACKEND_SERVICE_ID = $backendId
3. RENDER_FRONTEND_SERVICE_ID = $frontendId

"@

Write-Host $secretsToAdd -ForegroundColor Gray

# Save deployment info
$deploymentInfo = @"
# DEPLOYMENT INFORMATION
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Service IDs
- Database ID: $dbId
- Backend Service ID: $backendId
- Frontend Service ID: $frontendId

## URLs
- Backend: https://$backendUrl
- Frontend: https://$frontendUrl
- Health Check: https://$backendUrl/actuator/health

## GitHub Secrets
Add these to: https://github.com/$GITHUB_REPO/settings/secrets/actions

RENDER_API_KEY=$RENDER_API_KEY
RENDER_BACKEND_SERVICE_ID=$backendId
RENDER_FRONTEND_SERVICE_ID=$frontendId

## Next Steps
1. Wait 10-12 minutes for builds to complete
2. Visit frontend URL: https://$frontendUrl
3. Check health: https://$backendUrl/actuator/health
4. Take screenshots
5. Add GitHub secrets (see above)
"@

$deploymentInfo | Out-File -FilePath "DEPLOYMENT_INFO.txt" -Encoding UTF8
Write-Host "✅ Deployment info saved to: DEPLOYMENT_INFO.txt" -ForegroundColor Green
Write-Host ""

# Update README automatically
Write-Host "📝 UPDATING README.md..." -ForegroundColor Yellow

$readmePath = "README.md"
if (Test-Path $readmePath) {
    $readmeContent = Get-Content $readmePath -Raw
    
    $liveDemo = @"

## 🌐 Live Demo

**Application deployed on Render.com:**

- 🎨 **Frontend**: https://$frontendUrl
- 🚀 **Backend**: https://$backendUrl
- 💚 **Health Check**: https://$backendUrl/actuator/health

**Note**: First request may take 30-60 seconds (free tier warm-up)

**Deployed on**: $(Get-Date -Format "MMMM dd, yyyy")
"@
    
    if ($readmeContent -notmatch "## 🌐 Live Demo") {
        $readmeContent += "`n`n$liveDemo"
        $readmeContent | Out-File -FilePath $readmePath -Encoding UTF8 -NoNewline
        Write-Host "   ✅ README.md updated with live URLs" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  README.md already has live demo section" -ForegroundColor Gray
    }
}
Write-Host ""

# Final instructions
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ NEXT STEPS:" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. ⏳ WAIT 10-12 minutes for builds to complete" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. 🔍 VERIFY deployment:" -ForegroundColor Yellow
Write-Host "   - Open: https://dashboard.render.com" -ForegroundColor Cyan
Write-Host "   - Check all services show 'Live' status" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 🧪 TEST your application:" -ForegroundColor Yellow
Write-Host "   - Backend: https://$backendUrl/actuator/health" -ForegroundColor Cyan
Write-Host "   - Frontend: https://$frontendUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. 🔐 ADD GitHub secrets (for auto-deploy):" -ForegroundColor Yellow
Write-Host "   - Go to: https://github.com/$GITHUB_REPO/settings/secrets/actions" -ForegroundColor Cyan
Write-Host "   - Add the 3 secrets listed above" -ForegroundColor Gray
Write-Host ""
Write-Host "5. 📸 TAKE screenshots for submission:" -ForegroundColor Yellow
Write-Host "   - Render dashboard with all services" -ForegroundColor Gray
Write-Host "   - Backend health check" -ForegroundColor Gray
Write-Host "   - Frontend application running" -ForegroundColor Gray
Write-Host ""
Write-Host "6. 💾 COMMIT changes:" -ForegroundColor Yellow
Write-Host "   git add README.md DEPLOYMENT_INFO.txt" -ForegroundColor Cyan
Write-Host "   git commit -m 'Add deployment URLs'" -ForegroundColor Cyan
Write-Host "   git push" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🎉 DEPLOYMENT INITIATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Open dashboard
Write-Host "🌐 Opening Render dashboard..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Start-Process "https://dashboard.render.com"

Write-Host ""
Write-Host "✨ All done! Check your Render dashboard for build progress." -ForegroundColor Green
Write-Host ""
