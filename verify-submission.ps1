# DevOps Lab Midterm - Automated Verification Script
# Group-16 | Muhammad Waqar Ul Mulk, Ghulam Mujtaba
# Run this script to verify your submission is complete

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  DevOps Lab Midterm - Verification Script" -ForegroundColor Cyan
Write-Host "  Group-16 | FA22-BSE-153 | FA22-BSE-199" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$ErrorCount = 0
$WarningCount = 0

# Function to check
function Test-Requirement {
    param(
        [string]$Name,
        [scriptblock]$Test,
        [string]$SuccessMessage,
        [string]$ErrorMessage,
        [bool]$Critical = $true
    )
    
    Write-Host "Checking: $Name..." -NoNewline
    
    try {
        $result = & $Test
        if ($result) {
            Write-Host " ✓" -ForegroundColor Green
            Write-Host "  $SuccessMessage" -ForegroundColor DarkGray
            return $true
        } else {
            if ($Critical) {
                Write-Host " ✗ FAILED" -ForegroundColor Red
                Write-Host "  $ErrorMessage" -ForegroundColor Red
                $script:ErrorCount++
            } else {
                Write-Host " ⚠ WARNING" -ForegroundColor Yellow
                Write-Host "  $ErrorMessage" -ForegroundColor Yellow
                $script:WarningCount++
            }
            return $false
        }
    } catch {
        if ($Critical) {
            Write-Host " ✗ ERROR" -ForegroundColor Red
            Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
            $script:ErrorCount++
        } else {
            Write-Host " ⚠ WARNING" -ForegroundColor Yellow
            Write-Host "  $($_.Exception.Message)" -ForegroundColor Yellow
            $script:WarningCount++
        }
        return $false
    }
}

Write-Host ""
Write-Host "1. CHECKING PREREQUISITES" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Test-Requirement `
    -Name "Docker installed" `
    -Test { docker --version; $LASTEXITCODE -eq 0 } `
    -SuccessMessage "Docker is installed and accessible" `
    -ErrorMessage "Docker is not installed. Install Docker Desktop."

Test-Requirement `
    -Name "Docker Compose installed" `
    -Test { docker-compose --version; $LASTEXITCODE -eq 0 } `
    -SuccessMessage "Docker Compose is available" `
    -ErrorMessage "Docker Compose not found."

Test-Requirement `
    -Name "Git installed" `
    -Test { git --version; $LASTEXITCODE -eq 0 } `
    -SuccessMessage "Git is installed" `
    -ErrorMessage "Git is not installed."

Test-Requirement `
    -Name "Docker daemon running" `
    -Test { docker info *>&1 | Out-Null; $LASTEXITCODE -eq 0 } `
    -SuccessMessage "Docker daemon is running" `
    -ErrorMessage "Docker daemon not running. Start Docker Desktop."

Write-Host ""
Write-Host "2. CHECKING REPOSITORY STRUCTURE" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$RequiredFiles = @(
    ".github\workflows\ci-cd.yml",
    "ecom-backend\Dockerfile",
    "ecom-backend\pom.xml",
    "ecom-backend\src\main\java\com\jianquanwang\ecommerce\EcommerceApplication.java",
    "ecom-backend\src\test\java\com\jianquanwang\ecommerce\integration\DatabaseIntegrationTest.java",
    "ecom-frontend\Dockerfile",
    "ecom-frontend\package.json",
    "ecom-frontend\nginx.conf",
    "docker-compose.yml",
    ".env.example",
    ".gitignore",
    "README.md",
    "devops_report.md"
)

foreach ($file in $RequiredFiles) {
    Test-Requirement `
        -Name "File exists: $file" `
        -Test { Test-Path $file } `
        -SuccessMessage "File found" `
        -ErrorMessage "Required file missing: $file"
}

Write-Host ""
Write-Host "3. CHECKING FOR HARDCODED SECRETS" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Test-Requirement `
    -Name ".env not in repository" `
    -Test { -not (Test-Path ".env") -or (git check-ignore .env) } `
    -SuccessMessage ".env file is properly ignored or doesn't exist" `
    -ErrorMessage ".env file exists and might be tracked! Remove it: git rm --cached .env"

Test-Requirement `
    -Name ".gitignore includes .env" `
    -Test { (Get-Content .gitignore) -match "\.env" } `
    -SuccessMessage ".gitignore properly excludes .env" `
    -ErrorMessage "Add .env to .gitignore"

Test-Requirement `
    -Name "No hardcoded passwords in Java" `
    -Test { 
        $result = git grep -i "password.*=.*['\"].*['\"]" -- "*.java" "*.properties" 2>$null
        $LASTEXITCODE -ne 0 
    } `
    -SuccessMessage "No hardcoded passwords found" `
    -ErrorMessage "Found potential hardcoded passwords! Check application.properties"

Test-Requirement `
    -Name "application.properties uses env vars" `
    -Test { 
        $props = Get-Content "ecom-backend\src\main\resources\application.properties" -Raw
        $props -match '\$\{.*\}' 
    } `
    -SuccessMessage "Uses environment variables" `
    -ErrorMessage "application.properties should use \${VAR} syntax" `
    -Critical $false

Write-Host ""
Write-Host "4. CHECKING DOCKER FILES" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Test-Requirement `
    -Name "Backend Dockerfile has multi-stage" `
    -Test { 
        $content = Get-Content "ecom-backend\Dockerfile" -Raw
        ($content -match "FROM.*AS builder") -and ($content -match "FROM.*jre")
    } `
    -SuccessMessage "Multi-stage build detected" `
    -ErrorMessage "Backend Dockerfile should use multi-stage build"

Test-Requirement `
    -Name "Frontend Dockerfile has multi-stage" `
    -Test { 
        $content = Get-Content "ecom-frontend\Dockerfile" -Raw
        ($content -match "FROM.*node.*AS builder") -and ($content -match "FROM.*nginx")
    } `
    -SuccessMessage "Multi-stage build detected" `
    -ErrorMessage "Frontend Dockerfile should use multi-stage build"

Test-Requirement `
    -Name "docker-compose.yml has all services" `
    -Test { 
        $content = Get-Content "docker-compose.yml" -Raw
        ($content -match "db:") -and ($content -match "backend:") -and ($content -match "frontend:")
    } `
    -SuccessMessage "All 3 services defined (db, backend, frontend)" `
    -ErrorMessage "docker-compose.yml missing required services"

Test-Requirement `
    -Name "docker-compose.yml has volumes" `
    -Test { 
        $content = Get-Content "docker-compose.yml" -Raw
        $content -match "volumes:" -and $content -match "db_data"
    } `
    -SuccessMessage "Persistent volume configured" `
    -ErrorMessage "Missing database volume configuration"

Test-Requirement `
    -Name "docker-compose.yml has health checks" `
    -Test { 
        $content = Get-Content "docker-compose.yml" -Raw
        ($content -match "healthcheck:") -and ($content -match "pg_isready")
    } `
    -SuccessMessage "Health checks configured" `
    -ErrorMessage "Missing health check configuration"

Write-Host ""
Write-Host "5. CHECKING CI/CD PIPELINE" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$workflow = Get-Content ".github\workflows\ci-cd.yml" -Raw

Test-Requirement `
    -Name "Pipeline has 5 stages" `
    -Test { 
        ($workflow -match "build_install") -and 
        ($workflow -match "lint_security") -and 
        ($workflow -match "test_with_db") -and 
        ($workflow -match "build_docker_images") -and 
        ($workflow -match "deploy")
    } `
    -SuccessMessage "All 5 required stages present" `
    -ErrorMessage "Pipeline missing required stages"

Test-Requirement `
    -Name "Pipeline uses PostgreSQL service" `
    -Test { $workflow -match "services:" -and $workflow -match "postgres:" } `
    -SuccessMessage "PostgreSQL service configured for testing" `
    -ErrorMessage "Missing PostgreSQL service in test stage"

Test-Requirement `
    -Name "Pipeline pushes to Docker Hub" `
    -Test { $workflow -match "docker/build-push-action" -and $workflow -match "push: true" } `
    -SuccessMessage "Docker Hub push configured" `
    -ErrorMessage "Pipeline not configured to push images"

Test-Requirement `
    -Name "Pipeline uses secrets" `
    -Test { $workflow -match "secrets.DOCKERHUB_USERNAME" -and $workflow -match "secrets.DOCKERHUB_TOKEN" } `
    -SuccessMessage "GitHub Secrets properly referenced" `
    -ErrorMessage "Pipeline not using GitHub Secrets"

Write-Host ""
Write-Host "6. CHECKING TESTS" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Test-Requirement `
    -Name "Integration tests exist" `
    -Test { Test-Path "ecom-backend\src\test\java\com\jianquanwang\ecommerce\integration\DatabaseIntegrationTest.java" } `
    -SuccessMessage "Integration tests found" `
    -ErrorMessage "Integration tests missing"

Test-Requirement `
    -Name "Test configuration exists" `
    -Test { Test-Path "ecom-backend\src\test\resources\application-test.properties" } `
    -SuccessMessage "Test configuration found" `
    -ErrorMessage "Test configuration missing"

Write-Host ""
Write-Host "7. CHECKING DOCUMENTATION" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$readme = Get-Content "README.md" -Raw

Test-Requirement `
    -Name "README has team information" `
    -Test { $readme -match "MUHAMMAD WAQAR UL MULK" -and $readme -match "GHULAM MUJTABA" } `
    -SuccessMessage "Team members listed in README" `
    -ErrorMessage "Add team member information to README"

Test-Requirement `
    -Name "README has setup instructions" `
    -Test { $readme -match "docker-compose up" } `
    -SuccessMessage "Setup instructions present" `
    -ErrorMessage "Add setup instructions to README"

Test-Requirement `
    -Name "devops_report.md is complete" `
    -Test { 
        $report = Get-Content "devops_report.md" -Raw
        ($report -match "Technologies Used") -and 
        ($report -match "Pipeline Design") -and 
        ($report -match "Lessons Learned")
    } `
    -SuccessMessage "DevOps report is complete" `
    -ErrorMessage "Complete devops_report.md sections"

Write-Host ""
Write-Host "8. TESTING DOCKER BUILD" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Write-Host "Testing backend Docker build..." -ForegroundColor Yellow
$backendBuild = docker build -f ecom-backend\Dockerfile -t test-backend . 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Backend Docker build successful" -ForegroundColor Green
} else {
    Write-Host "✗ Backend Docker build failed" -ForegroundColor Red
    Write-Host $backendBuild | Select-Object -Last 10
    $script:ErrorCount++
}

Write-Host "Testing frontend Docker build..." -ForegroundColor Yellow
$frontendBuild = docker build -f ecom-frontend\Dockerfile -t test-frontend . 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Frontend Docker build successful" -ForegroundColor Green
} else {
    Write-Host "✗ Frontend Docker build failed" -ForegroundColor Red
    Write-Host $frontendBuild | Select-Object -Last 10
    $script:ErrorCount++
}

# Clean up test images
docker rmi test-backend test-frontend 2>&1 | Out-Null

Write-Host ""
Write-Host "9. CHECKING GIT STATUS" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Test-Requirement `
    -Name "No uncommitted changes" `
    -Test { (git status --porcelain).Count -eq 0 } `
    -SuccessMessage "Working directory clean" `
    -ErrorMessage "You have uncommitted changes. Commit them before submission." `
    -Critical $false

Test-Requirement `
    -Name "On main or master branch" `
    -Test { 
        $branch = git branch --show-current
        $branch -eq "main" -or $branch -eq "master"
    } `
    -SuccessMessage "On main branch" `
    -ErrorMessage "Switch to main branch before submission" `
    -Critical $false

Test-Requirement `
    -Name "Multiple commits exist" `
    -Test { (git log --oneline | Measure-Object).Count -gt 5 } `
    -SuccessMessage "Good commit history" `
    -ErrorMessage "Need more commits (at least 5)" `
    -Critical $false

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "VERIFICATION SUMMARY" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

if ($ErrorCount -eq 0 -and $WarningCount -eq 0) {
    Write-Host "✓ ALL CHECKS PASSED!" -ForegroundColor Green
    Write-Host "Your submission appears to be complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Push to GitHub: git push origin main" -ForegroundColor White
    Write-Host "2. Wait for CI/CD pipeline to complete" -ForegroundColor White
    Write-Host "3. Verify images on Docker Hub" -ForegroundColor White
    Write-Host "4. Capture screenshots (see SCREENSHOTS_GUIDE.md)" -ForegroundColor White
    Write-Host "5. Submit to Google Classroom" -ForegroundColor White
} elseif ($ErrorCount -eq 0) {
    Write-Host "⚠ PASSED WITH WARNINGS ($WarningCount warnings)" -ForegroundColor Yellow
    Write-Host "Review warnings above and fix if possible" -ForegroundColor Yellow
} else {
    Write-Host "✗ VERIFICATION FAILED" -ForegroundColor Red
    Write-Host "Errors: $ErrorCount | Warnings: $WarningCount" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please fix all errors before submission!" -ForegroundColor Red
    Write-Host "See details above for what needs to be fixed." -ForegroundColor Red
}

Write-Host ""
Write-Host "For detailed submission instructions, see:" -ForegroundColor Cyan
Write-Host "- SUBMISSION_CHECKLIST.md" -ForegroundColor White
Write-Host "- QUICK_START.md" -ForegroundColor White
Write-Host "- SCREENSHOTS_GUIDE.md" -ForegroundColor White
Write-Host ""

# Exit with error code if there are errors
if ($ErrorCount -gt 0) {
    exit 1
} else {
    exit 0
}
