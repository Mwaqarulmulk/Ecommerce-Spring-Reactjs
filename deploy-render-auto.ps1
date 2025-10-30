# AUTOMATIC RENDER DEPLOYMENT SCRIPT
# Uses Render Blueprint API

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 AUTO-DEPLOYING TO RENDER" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$RENDER_API_KEY = "rnd_dDmVRQFB82oTLl56P8aa8ZG6yrpU"
$GITHUB_REPO_URL = "https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs"
$BRANCH = "master"

Write-Host "📋 Configuration:" -ForegroundColor Yellow
Write-Host "   Repository: $GITHUB_REPO_URL" -ForegroundColor Gray
Write-Host "   Branch: $BRANCH" -ForegroundColor Gray
Write-Host "   Blueprint: render.yaml" -ForegroundColor Gray
Write-Host ""

# Step 1: Get Owner ID
Write-Host "🔍 Step 1: Getting your Render account info..." -ForegroundColor Yellow
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $RENDER_API_KEY"
    "Content-Type" = "application/json"
}

try {
    Write-Host "   Fetching account details..." -ForegroundColor Cyan
    $account = Invoke-RestMethod -Uri "https://api.render.com/v1/owners" `
        -Method Get `
        -Headers $headers `
        -ErrorAction Stop
    
    $ownerId = $account[0].owner.id
    Write-Host "   ✅ Account found!" -ForegroundColor Green
    Write-Host "   Owner ID: $ownerId" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "   ❌ Failed to get account info: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔗 MANUAL DEPLOYMENT REQUIRED:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please deploy using the web interface:" -ForegroundColor White
    Write-Host "https://render.com/deploy?repo=$GITHUB_REPO_URL" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or follow the manual guide: DEPLOY_NOW.md" -ForegroundColor White
    Write-Host ""
    Start-Process "https://render.com/deploy?repo=$GITHUB_REPO_URL"
    exit 0
}

# Step 2: Deploy using Blueprint
Write-Host "🚀 Step 2: Deploying services from render.yaml..." -ForegroundColor Yellow
Write-Host ""

$blueprintPayload = @{
    serviceType = "blueprint"
    name = "DEVOPS-MID-Lab-Exam"
    ownerId = $ownerId
    repo = $GITHUB_REPO_URL
    branch = $BRANCH
    blueprintPath = "render.yaml"
} | ConvertTo-Json -Depth 10

try {
    Write-Host "   Creating blueprint deployment..." -ForegroundColor Cyan
    $blueprint = Invoke-RestMethod -Uri "https://api.render.com/v1/blueprints" `
        -Method Post `
        -Headers $headers `
        -Body $blueprintPayload `
        -ErrorAction Stop
    
    Write-Host "   ✅ Blueprint deployment created!" -ForegroundColor Green
    Write-Host "   Blueprint ID: $($blueprint.id)" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "   🔄 Services being created:" -ForegroundColor Cyan
    foreach ($service in $blueprint.services) {
        Write-Host "      • $($service.name) ($($service.type))" -ForegroundColor Gray
    }
    Write-Host ""
    
} catch {
    Write-Host "   ⚠️ Blueprint API deployment failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "   📌 Using fallback: One-Click Deploy..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Opening deployment page..." -ForegroundColor Cyan
    Start-Process "https://render.com/deploy?repo=$GITHUB_REPO_URL"
    Write-Host ""
    Write-Host "   ✅ Deployment page opened in browser!" -ForegroundColor Green
    Write-Host "   👆 Click the blue 'Apply' button to deploy" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

# Step 3: Monitor deployment
Write-Host "⏳ Step 3: Monitoring deployment progress..." -ForegroundColor Yellow
Write-Host ""
Write-Host "   Services are now deploying. This takes 10-15 minutes." -ForegroundColor Gray
Write-Host ""

Start-Sleep -Seconds 5

# Get services
try {
    $services = Invoke-RestMethod -Uri "https://api.render.com/v1/services?limit=50" `
        -Method Get `
        -Headers $headers `
        -ErrorAction Stop
    
    $backendService = $services | Where-Object { $_.service.name -like "*backend*" } | Select-Object -First 1
    $frontendService = $services | Where-Object { $_.service.name -like "*frontend*" } | Select-Object -First 1
    $dbService = $services | Where-Object { $_.service.name -like "*db*" } | Select-Object -First 1
    
    if ($backendService) {
        $backendUrl = "https://$($backendService.service.serviceDetails.url)"
        $backendId = $backendService.service.id
    } else {
        $backendUrl = "https://ecommerce-backend-XXXX.onrender.com"
        $backendId = "srv-XXXX"
    }
    
    if ($frontendService) {
        $frontendUrl = "https://$($frontendService.service.serviceDetails.url)"
        $frontendId = $frontendService.service.id
    } else {
        $frontendUrl = "https://ecommerce-frontend-XXXX.onrender.com"
        $frontendId = "srv-XXXX"
    }
    
    if ($dbService) {
        $dbId = $dbService.service.id
    } else {
        $dbId = "dpg-XXXX"
    }
    
} catch {
    Write-Host "   ⚠️ Could not fetch service details yet" -ForegroundColor Yellow
    $backendUrl = "https://ecommerce-backend-XXXX.onrender.com"
    $frontendUrl = "https://ecommerce-frontend-XXXX.onrender.com"
    $backendId = "srv-XXXX"
    $frontendId = "srv-XXXX"
    $dbId = "dpg-XXXX"
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ DEPLOYMENT INITIATED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 YOUR SERVICES:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   🗄️  Database:" -ForegroundColor White
Write-Host "       ID: $dbId" -ForegroundColor Gray
Write-Host "       Status: Provisioning (2-3 min)" -ForegroundColor Gray
Write-Host ""
Write-Host "   🚀 Backend:" -ForegroundColor White
Write-Host "       ID: $backendId" -ForegroundColor Gray
Write-Host "       URL: $backendUrl" -ForegroundColor Cyan
Write-Host "       Health: $backendUrl/actuator/health" -ForegroundColor Gray
Write-Host "       Status: Building (8-10 min)" -ForegroundColor Gray
Write-Host ""
Write-Host "   🎨 Frontend:" -ForegroundColor White
Write-Host "       ID: $frontendId" -ForegroundColor Gray
Write-Host "       URL: $frontendUrl" -ForegroundColor Cyan
Write-Host "       Status: Building (3-5 min)" -ForegroundColor Gray
Write-Host ""

Write-Host "⏰ TOTAL TIME: ~15 minutes" -ForegroundColor Yellow
Write-Host ""

Write-Host "📊 MONITOR DEPLOYMENT:" -ForegroundColor Yellow
Write-Host "   Dashboard: https://dashboard.render.com" -ForegroundColor Cyan
Write-Host ""

# Save deployment info
$deploymentInfo = @"
DEPLOYMENT INFORMATION
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Service IDs:
- Database: $dbId
- Backend: $backendId
- Frontend: $frontendId

URLs:
- Backend: $backendUrl
- Frontend: $frontendUrl
- Health: $backendUrl/actuator/health

GitHub Secrets to Add:
https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs/settings/secrets/actions

1. RENDER_API_KEY=$RENDER_API_KEY
2. RENDER_BACKEND_SERVICE_ID=$backendId
3. RENDER_FRONTEND_SERVICE_ID=$frontendId

Next Steps:
1. Wait 15 minutes for builds
2. Check dashboard: https://dashboard.render.com
3. Test backend: $backendUrl/actuator/health
4. Test frontend: $frontendUrl
5. Take screenshots
6. Add GitHub secrets
"@

$deploymentInfo | Out-File -FilePath "RENDER_DEPLOYMENT_INFO.txt" -Encoding UTF8
Write-Host "✅ Info saved to: RENDER_DEPLOYMENT_INFO.txt" -ForegroundColor Green
Write-Host ""

# Open dashboard
Write-Host "🌐 Opening Render dashboard..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Start-Process "https://dashboard.render.com"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ NEXT STEPS:" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. ⏳ WAIT 15 minutes for builds to complete" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. 🔍 CHECK Render dashboard for service status" -ForegroundColor Yellow
Write-Host "   All services should show 'Live'" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 🧪 TEST your services:" -ForegroundColor Yellow
Write-Host "   Backend: $backendUrl/actuator/health" -ForegroundColor Cyan
Write-Host "   Frontend: $frontendUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. 🔐 ADD GitHub secrets (see RENDER_DEPLOYMENT_INFO.txt)" -ForegroundColor Yellow
Write-Host ""
Write-Host "5. 📸 TAKE screenshots for submission" -ForegroundColor Yellow
Write-Host ""
Write-Host "🎉 Deployment process started successfully!" -ForegroundColor Green
Write-Host ""
