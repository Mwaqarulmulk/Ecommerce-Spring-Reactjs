# ⚡ EXPRESS SUBMISSION GUIDE - 30 Minutes

**Group-16** | Muhammad Waqar Ul Mulk, Ghulam Mujtaba  
**Last Minute? Follow this guide EXACTLY!**

---

## 🎯 Mission: Complete DevOps Lab in 30 Minutes

### ⏰ Timeline Breakdown
- **0-5 min**: Setup & Configuration
- **5-15 min**: Run verification & tests
- **15-25 min**: GitHub Actions & Docker Hub
- **25-30 min**: Screenshots & submission

---

## ✅ STEP 1: Initial Setup (5 minutes)

### 1.1 Open PowerShell as Administrator

```powershell
# Navigate to project
cd E:\Ecommerce-Spring-Reactjs

# Verify location
pwd
```

### 1.2 Configure Environment

```powershell
# Copy environment template
Copy-Item .env.example .env

# Edit .env with your Docker Hub username
notepad .env
```

**Edit these lines in .env:**
```
DOCKERHUB_USERNAME=ghulam-mujtaba5
POSTGRES_PASSWORD=SecurePass123!
```

Save and close.

### 1.3 Verify Prerequisites

```powershell
# Run verification script
.\verify-submission.ps1
```

**If errors appear:**
- Docker not running? → Start Docker Desktop, wait 2 minutes
- Git not found? → Install from https://git-scm.com
- Other errors? → Read error message and fix

---

## ✅ STEP 2: Test Locally (5 minutes)

### 2.1 Start All Services

```powershell
# Build and start (this takes ~5 minutes)
docker-compose up -d --build
```

**Wait for build to complete...**

### 2.2 Verify Services Running

```powershell
# Check all containers healthy
docker-compose ps

# Should see:
# ecom-db         Up (healthy)
# ecom-backend    Up (healthy)
# ecom-frontend   Up (healthy)
```

### 2.3 Quick Test

```powershell
# Test backend
curl http://localhost:5000/actuator/health
# Should return: {"status":"UP"}

# Test frontend (open in browser)
start http://localhost
```

**If any service is unhealthy:**
```powershell
docker-compose logs <service-name>
# Fix the error and restart:
docker-compose restart <service-name>
```

### 2.4 Stop Services

```powershell
# Stop everything
docker-compose down -v
```

---

## ✅ STEP 3: GitHub Setup (10 minutes)

### 3.1 Create/Update Repository

**If repository doesn't exist:**
```powershell
# Create on GitHub first, then:
git init
git add .
git commit -m "Initial commit - DevOps Lab Midterm"
git branch -M main
git remote add origin https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs.git
git push -u origin main
```

**If repository exists:**
```powershell
git add .
git commit -m "Complete DevOps Lab implementation"
git push origin main
```

### 3.2 Configure GitHub Secrets

**CRITICAL: Do this NOW!**

1. Go to: https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs/settings/secrets/actions

2. Click **"New repository secret"**

3. Add first secret:
   - Name: `DOCKERHUB_USERNAME`
   - Value: `ghulam-mujtaba5`
   - Click **"Add secret"**

4. Add second secret:
   - Name: `DOCKERHUB_TOKEN`
   - Value: [Get from https://hub.docker.com/settings/security]
   - Click **"Add secret"**

**To get Docker Hub token:**
- Login to https://hub.docker.com
- Account Settings → Security → New Access Token
- Description: "GitHub Actions"
- Access permissions: Read, Write, Delete
- **Copy token NOW** (you won't see it again!)

### 3.3 Trigger Pipeline

```powershell
# Make sure latest code is pushed
git status
git push origin main

# Check pipeline status
start https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs/actions
```

**Pipeline will take ~30-40 minutes**

⚠️ **Don't wait! Continue with screenshots while it runs**

---

## ✅ STEP 4: Screenshots (30 minutes - DO WHILE PIPELINE RUNS)

### Essential Screenshots (Minimum Required)

#### Group A: Repository (5 screenshots)

```powershell
# Take these from GitHub
start https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs
```

1. **Main repository page** - showing README
2. **File structure** - showing all folders
3. **docker-compose.yml** - file content
4. **CI/CD workflow** - .github/workflows/ci-cd.yml
5. **Contributors** - Insights → Contributors (showing both members)

#### Group B: Docker Files (3 screenshots)

From GitHub:
6. **Backend Dockerfile** - ecom-backend/Dockerfile (show multi-stage)
7. **Frontend Dockerfile** - ecom-frontend/Dockerfile (show multi-stage)
8. **Nginx config** - ecom-frontend/nginx.conf

#### Group C: Running Containers (5 screenshots)

```powershell
# Start containers again
docker-compose up -d --build

# Wait 2 minutes for healthy status
Start-Sleep -Seconds 120
```

9. **docker-compose ps output** - showing all healthy
10. **Backend logs** - `docker-compose logs backend | Select-Object -Last 50`
11. **Frontend in browser** - http://localhost screenshot
12. **Backend health check** - http://localhost:5000/actuator/health
13. **docker images** - `docker images | Select-String "ecom"`

#### Group D: CI/CD Pipeline (10 screenshots)

From: https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs/actions

⏳ **WAIT for pipeline to finish first!**

14. **Actions tab** - list of workflow runs
15. **Successful run** - overview showing all 5 jobs passed
16. **Stage 1 logs** - Build & Install
17. **Stage 2 logs** - Lint & Security Scan
18. **Stage 3 logs** - Test with Database (show PostgreSQL starting)
19. **Stage 4 logs** - Build Docker Images (show push to Docker Hub)
20. **Stage 5 logs** - Deploy
21. **Test results** - from Stage 3
22. **Artifacts** - bottom of page showing build-artifacts, test-reports
23. **Workflow file** - .github/workflows/ci-cd.yml in GitHub

#### Group E: Docker Hub (5 screenshots)

From: https://hub.docker.com/u/ghulam-mujtaba5

24. **Backend repository** - hub.docker.com/r/ghulam-mujtaba5/ecom-backend
25. **Backend tags** - showing latest, main, SHA tags
26. **Backend timestamp** - "Last pushed" must be within exam period
27. **Frontend repository** - hub.docker.com/r/ghulam-mujtaba5/ecom-frontend
28. **Frontend tags** - showing tags

#### Group F: Secrets & Documentation (5 screenshots)

29. **GitHub Secrets** - Settings → Secrets (showing 2 secrets, values hidden)
30. **.env.example** - showing no hardcoded secrets
31. **README.md preview** - showing team info
32. **devops_report.md preview** - showing sections
33. **Integration test file** - DatabaseIntegrationTest.java

### Screenshot Organization

```powershell
# Create folders
New-Item -ItemType Directory -Force screenshots\1-repository
New-Item -ItemType Directory -Force screenshots\2-docker
New-Item -ItemType Directory -Force screenshots\3-cicd
New-Item -ItemType Directory -Force screenshots\4-dockerhub
New-Item -ItemType Directory -Force screenshots\5-docs
```

Save screenshots with names like:
- `1-repository-main.png`
- `3-cicd-stage1-build.png`
- `4-dockerhub-backend-tags.png`

---

## ✅ STEP 5: Final Verification (5 minutes)

### 5.1 Run Verification Script

```powershell
.\verify-submission.ps1
```

Should show: **"✓ ALL CHECKS PASSED!"**

### 5.2 Verify Pipeline Passed

```powershell
start https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs/actions
```

All 5 stages should be **green checkmarks** ✓

### 5.3 Verify Docker Hub

```powershell
start https://hub.docker.com/u/ghulam-mujtaba5
```

Should see:
- `ecom-backend` repository with tags
- `ecom-frontend` repository with tags
- **"Last pushed"** timestamp within exam period

### 5.4 Final Checklist

- [ ] ✅ GitHub repository is public
- [ ] ✅ Both team members have commits (check Contributors)
- [ ] ✅ CI/CD pipeline passed (all 5 stages green)
- [ ] ✅ Docker images on Docker Hub
- [ ] ✅ Timestamps correct (within exam period)
- [ ] ✅ No hardcoded passwords (.env not in repo)
- [ ] ✅ README.md has team info
- [ ] ✅ devops_report.md is complete
- [ ] ✅ Screenshots captured (minimum 33)

---

## ✅ STEP 6: Create Submission Package (5 minutes)

### 6.1 Create Submission ZIP

```powershell
# Create submission folder
New-Item -ItemType Directory -Force Submission-Group16

# Copy code (exclude unnecessary files)
Get-ChildItem -Exclude @("node_modules","target",".git") | 
    Copy-Item -Destination Submission-Group16\ -Recurse -Force

# Copy screenshots
Copy-Item screenshots Submission-Group16\ -Recurse -Force

# Create info file
@"
DevOps Lab Midterm Submission
==============================
Group: 16
Members:
- Muhammad Waqar Ul Mulk (FA22-BSE-153)
- Ghulam Mujtaba (FA22-BSE-199)

GitHub: https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs
Docker Hub: https://hub.docker.com/u/ghulam-mujtaba5

Submission Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
"@ | Out-File Submission-Group16\SUBMISSION_INFO.txt

# Create ZIP
Compress-Archive -Path Submission-Group16\* -DestinationPath Group16-DevOps-Midterm.zip -Force

Write-Host "✓ Created: Group16-DevOps-Midterm.zip" -ForegroundColor Green
```

### 6.2 Verify ZIP Contents

```powershell
# List ZIP contents
Expand-Archive Group16-DevOps-Midterm.zip -DestinationPath temp-verify -Force
Get-ChildItem temp-verify -Recurse -Name
Remove-Item temp-verify -Recurse -Force
```

Should contain:
- `.github/workflows/ci-cd.yml`
- `ecom-backend/` (with Dockerfile)
- `ecom-frontend/` (with Dockerfile)
- `docker-compose.yml`
- `README.md`
- `devops_report.md`
- `screenshots/` (with subdirectories)
- `SUBMISSION_INFO.txt`

---

## ✅ STEP 7: Submit to Google Classroom

### 7.1 Prepare Submission Text

Copy this template:

```
DevOps Lab Midterm - Group 16

Team Members:
- Muhammad Waqar Ul Mulk (FA22-BSE-153)
- Ghulam Mujtaba (FA22-BSE-199)

GitHub Repository (Public):
https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs

Docker Hub Profile:
https://hub.docker.com/u/ghulam-mujtaba5

Docker Images:
- Backend: https://hub.docker.com/r/ghulam-mujtaba5/ecom-backend
- Frontend: https://hub.docker.com/r/ghulam-mujtaba5/ecom-frontend

CI/CD Pipeline Status: ✓ PASSED (All 5 stages)
Pipeline URL: https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs/actions

Submission includes:
✓ Complete source code
✓ Docker Compose with 3 services
✓ Multi-stage Dockerfiles
✓ GitHub Actions workflow (5 stages)
✓ Integration tests with PostgreSQL
✓ Security scanning (Trivy + npm audit)
✓ Complete documentation (README + DevOps Report)
✓ Screenshots (33+ images)
✓ No hardcoded passwords

Timestamp Verification:
- Latest commit: [Git SHA]
- Pipeline run: [Workflow run #]
- Docker Hub push: [Last pushed timestamp]

All timestamps are within the exam period.
```

### 7.2 Submit

1. Go to Google Classroom assignment
2. Click "Add or create" → "File"
3. Upload `Group16-DevOps-Midterm.zip`
4. Paste the submission text above
5. Click "Turn in"
6. **Verify submission appears in "Turned in" section**

---

## 🆘 TROUBLESHOOTING

### Problem: Pipeline Failed

```powershell
# Check which stage failed
start https://github.com/ghulam-mujtaba5/Ecommerce-Spring-Reactjs/actions

# Common fixes:
# 1. Secrets not configured → Add them in Settings → Secrets
# 2. Docker Hub auth failed → Regenerate token
# 3. Tests failed → Run locally: cd ecom-backend; mvn test
# 4. Build failed → Check logs for errors

# After fixing, retrigger:
git commit --allow-empty -m "Retrigger pipeline"
git push origin main
```

### Problem: Docker Compose Fails

```powershell
# Check logs
docker-compose logs

# Common fixes:
# 1. Port conflict → Stop other services on ports 80, 5000, 5432
# 2. Docker not running → Start Docker Desktop
# 3. Build error → Check Dockerfile syntax

# Restart:
docker-compose down -v
docker-compose up -d --build
```

### Problem: Can't Push to GitHub

```powershell
# If authentication fails:
git config --global user.email "your-email@example.com"
git config --global user.name "Ghulam Mujtaba"

# Use personal access token instead of password
# Generate at: https://github.com/settings/tokens
```

### Problem: Missing Screenshots

**Priority screenshots (must have):**
1. CI/CD pipeline passed (all 5 stages green)
2. Docker Hub images with timestamp
3. docker-compose ps (all healthy)
4. GitHub contributors (both members)
5. No hardcoded passwords (.env.example)

**Capture these FIRST if time is limited**

---

## ⚡ EMERGENCY MODE (< 15 minutes left)

**If you have less than 15 minutes:**

1. ✅ **MUST DO:**
   - Push code to GitHub
   - Configure GitHub Secrets
   - Trigger CI/CD pipeline
   - Capture pipeline screenshot (even if running)
   - Submit what you have

2. ✅ **Screenshot Priority:**
   - CI/CD workflow file
   - Docker compose file
   - Pipeline run (even if in progress)
   - Docker Hub repos
   - GitHub secrets page

3. ✅ **Submission:**
   - Create ZIP with code + screenshots
   - Submit to Google Classroom
   - Add note: "Pipeline in progress, see GitHub Actions"

**Better partial submission than no submission!**

---

## ✨ SUCCESS INDICATORS

You know you're done when:
- ✅ GitHub repository is public with all code
- ✅ GitHub Actions shows green checkmarks for all 5 stages
- ✅ Docker Hub has your images with correct timestamps
- ✅ Screenshots folder has 30+ organized images
- ✅ ZIP file uploaded to Google Classroom
- ✅ Confirmation message received

---

## 📞 FINAL REMINDER

**Before you submit, verify these 4 critical items:**

1. ❌ **NO HARDCODED PASSWORDS** → Use environment variables
2. ⏰ **TIMESTAMPS CORRECT** → Within exam period
3. 👥 **BOTH MEMBERS CONTRIBUTED** → Check Git commits
4. 🔓 **REPOSITORY IS PUBLIC** → Anyone can view

**If all 4 are good, you're ready to submit!**

---

**Good luck! You got this! 🚀**

**Time spent reading this: 3 minutes**  
**Time to complete: 27 minutes**  
**Total: 30 minutes** ⏰
