# Quick Setup Guide - DevOps Lab Midterm

**Group-16** | Muhammad Waqar Ul Mulk (FA22-BSE-153), Ghulam Mujtaba (FA22-BSE-199)

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Clone Repository

```powershell
git clone https://github.com/<your-username>/Ecommerce-Spring-Reactjs.git
cd Ecommerce-Spring-Reactjs
```

### Step 2: Configure Environment

```powershell
# Copy example environment file
Copy-Item .env.example .env

# Edit .env and update these values:
# - DOCKERHUB_USERNAME=your_dockerhub_username
# - POSTGRES_PASSWORD=your_strong_password
```

### Step 3: Start Application

```powershell
# Start all services with Docker Compose
docker-compose up -d --build
```

### Step 4: Verify Services

```powershell
# Check all containers are running
docker-compose ps

# Should show:
# - ecom-db (healthy)
# - ecom-backend (healthy)
# - ecom-frontend (healthy)
```

### Step 5: Access Application

- **Frontend**: http://localhost
- **Backend API**: http://localhost:5000
- **Health Check**: http://localhost:5000/actuator/health

---

## 🔧 Complete Setup (15 Minutes)

### Prerequisites Installation

#### 1. Install Docker Desktop

**Windows:**
```powershell
# Download from https://www.docker.com/products/docker-desktop
# Run installer and restart
# Verify installation:
docker --version
docker-compose --version
```

#### 2. Install Git

```powershell
# Download from https://git-scm.com/download/win
# Verify:
git --version
```

#### 3. Install Java JDK 21 (Optional - for local development)

```powershell
# Download from https://www.oracle.com/java/technologies/downloads/#java21
# Or use Chocolatey:
choco install openjdk21

# Verify:
java -version
```

#### 4. Install Node.js 18+ (Optional - for local development)

```powershell
# Download from https://nodejs.org/
# Or use Chocolatey:
choco install nodejs-lts

# Verify:
node --version
npm --version
```

#### 5. Install Maven (Optional - for local development)

```powershell
# Download from https://maven.apache.org/download.cgi
# Or use Chocolatey:
choco install maven

# Verify:
mvn --version
```

---

## 📝 GitHub Actions Setup

### Step 1: Create Docker Hub Account

1. Go to https://hub.docker.com/
2. Sign up for free account
3. Verify email

### Step 2: Generate Docker Hub Access Token

1. Login to Docker Hub
2. Go to: Account Settings → Security → New Access Token
3. Token Description: "GitHub Actions CI/CD"
4. Access Permissions: Read, Write, Delete
5. Copy token (you won't see it again!)

### Step 3: Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to: Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add two secrets:

**Secret 1:**
- Name: `DOCKERHUB_USERNAME`
- Value: `your_dockerhub_username`

**Secret 2:**
- Name: `DOCKERHUB_TOKEN`
- Value: `paste_your_token_here`

### Step 4: Trigger Pipeline

```powershell
# Make any change and push
git add .
git commit -m "Trigger CI/CD pipeline"
git push origin main
```

### Step 5: Monitor Pipeline

1. Go to GitHub → Actions tab
2. Watch the pipeline execute
3. Check all 5 stages pass:
   - ✅ Build & Install
   - ✅ Lint & Security Scan
   - ✅ Test with Database
   - ✅ Build Docker Images
   - ✅ Deploy

---

## 🏗️ Local Development Workflow

### Option 1: Docker Compose (Recommended)

```powershell
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Restart a service
docker-compose restart backend

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Option 2: Run Services Individually

#### Backend:

```powershell
cd ecom-backend

# Build
mvn clean package -DskipTests

# Run
mvn spring-boot:run

# Or run JAR
java -jar target/Ecommerce-0.0.1-SNAPSHOT.jar

# Access: http://localhost:5000
```

#### Frontend:

```powershell
cd ecom-frontend

# Install dependencies
npm ci

# Development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Access: http://localhost:5173 (dev) or http://localhost:4173 (preview)
```

#### Database:

```powershell
# Start PostgreSQL with Docker
docker run -d `
  --name postgres-dev `
  -e POSTGRES_DB=ecommerce `
  -e POSTGRES_USER=ecomuser `
  -e POSTGRES_PASSWORD=changeme `
  -p 5432:5432 `
  postgres:15-alpine

# Connect to database
docker exec -it postgres-dev psql -U ecomuser -d ecommerce
```

---

## 🧪 Testing Guide

### Run All Tests

```powershell
# Backend tests
cd ecom-backend
mvn test

# Frontend tests (if configured)
cd ecom-frontend
npm test -- --watchAll=false
```

### Run Specific Test

```powershell
# Specific test class
mvn test -Dtest=DatabaseIntegrationTest

# Specific test method
mvn test -Dtest=DatabaseIntegrationTest#testDatabaseConnection
```

### Run Tests with Database (Integration Tests)

```powershell
# Start PostgreSQL first
docker-compose up -d db

# Wait for database to be ready
Start-Sleep -Seconds 10

# Run tests with test profile
mvn test -Dspring.profiles.active=test
```

### Check Test Coverage

```powershell
mvn clean verify jacoco:report
# Report: ecom-backend/target/site/jacoco/index.html
```

---

## 🔒 Security Best Practices

### Never Commit Secrets

```powershell
# Check .gitignore includes
cat .gitignore | Select-String "env"

# Verify .env is not tracked
git status

# If .env is tracked (RED FLAG):
git rm --cached .env
git commit -m "Remove .env from tracking"
```

### Generate Strong JWT Secret

```powershell
# Generate random 64-character key
$bytes = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($bytes)
[Convert]::ToBase64String($bytes)

# Update in .env:
# SPRING_APP_JWTSECRET=<generated_key>
```

### Rotate Docker Hub Token

```powershell
# Every 3 months:
# 1. Generate new token on Docker Hub
# 2. Update GitHub Secret
# 3. Revoke old token
```

---

## 🐛 Troubleshooting

### Issue: Docker containers not starting

```powershell
# Check Docker Desktop is running
docker info

# Check for port conflicts
netstat -ano | Select-String ":5432|:5000|:80"

# Restart Docker Desktop
# Or change ports in docker-compose.yml
```

### Issue: Database connection failed

```powershell
# Check database is healthy
docker-compose ps

# View database logs
docker-compose logs db

# Verify credentials match
docker-compose exec db env | Select-String "POSTGRES"

# Test connection
docker-compose exec db pg_isready -U ecomuser
```

### Issue: Backend build fails

```powershell
# Clean Maven cache
mvn clean

# Update dependencies
mvn dependency:resolve

# Check Java version
java -version  # Should be 21

# Rebuild
mvn clean package
```

### Issue: Frontend build fails

```powershell
# Clear npm cache
npm cache clean --force

# Delete node_modules
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json

# Reinstall
npm install

# Rebuild
npm run build
```

### Issue: Pipeline fails on GitHub Actions

```powershell
# Check logs in Actions tab
# Common issues:

# 1. Missing secrets
# Solution: Add DOCKERHUB_USERNAME and DOCKERHUB_TOKEN

# 2. Test failures
# Solution: Run tests locally first

# 3. Docker Hub authentication
# Solution: Verify token is valid and has write permissions

# 4. Out of disk space
# Solution: Clean up old workflow runs
```

### Issue: Cannot push to Docker Hub

```powershell
# Login locally
docker login

# Test push manually
docker tag local-image:latest username/repo:test
docker push username/repo:test

# Check token permissions
# Ensure token has Read, Write permissions
```

---

## 📊 Monitoring & Logs

### View Real-time Logs

```powershell
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail=100 backend

# Since specific time
docker-compose logs --since 2024-10-30T10:00:00 backend
```

### Check Resource Usage

```powershell
# Container stats
docker stats

# Specific container
docker stats ecom-backend
```

### Database Queries

```powershell
# Connect to database
docker-compose exec db psql -U ecomuser -d ecommerce

# Inside psql:
\dt                  # List tables
\d+ category         # Describe table
SELECT * FROM category;
\q                   # Quit
```

### Backend API Testing

```powershell
# Health check
curl http://localhost:5000/actuator/health

# API endpoints (requires authentication)
curl http://localhost:5000/api/categories

# With authentication
$token = "your_jwt_token"
curl -H "Authorization: Bearer $token" http://localhost:5000/api/products
```

---

## 🔄 CI/CD Pipeline Customization

### Modify Workflow Triggers

Edit `.github/workflows/ci-cd.yml`:

```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # Add more branches
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * 0'  # Weekly on Sunday 2 AM
```

### Add Slack Notifications

```yaml
- name: Notify Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Add Deployment to Cloud

```yaml
- name: Deploy to Render
  env:
    RENDER_API_KEY: ${{ secrets.RENDER_API_KEY }}
  run: |
    curl -X POST https://api.render.com/v1/services/$SERVICE_ID/deploys \
      -H "Authorization: Bearer $RENDER_API_KEY"
```

---

## 📦 Production Deployment

### Option 1: Docker Compose on Server

```powershell
# SSH to server
ssh user@your-server.com

# Clone repository
git clone https://github.com/your-username/Ecommerce-Spring-Reactjs.git
cd Ecommerce-Spring-Reactjs

# Configure environment
cp .env.example .env
nano .env  # Edit with production values

# Start services
docker-compose up -d

# Setup Nginx reverse proxy (optional)
# Setup SSL with Let's Encrypt (recommended)
```

### Option 2: Deploy to Render

1. Create account on https://render.com
2. Connect GitHub repository
3. Create services:
   - Web Service (Backend) - Docker
   - Static Site (Frontend) - Docker
   - PostgreSQL Database - Managed
4. Configure environment variables
5. Deploy automatically on push to main

### Option 3: Deploy to Railway

1. Create account on https://railway.app
2. New Project → Deploy from GitHub
3. Add PostgreSQL database
4. Configure services
5. Deploy

---

## ✅ Final Checklist Before Submission

### Code Quality
- [ ] No hardcoded passwords
- [ ] All sensitive data in .env
- [ ] .env in .gitignore
- [ ] Code properly formatted
- [ ] No console.log in production

### Documentation
- [ ] README.md complete
- [ ] devops_report.md complete
- [ ] SCREENSHOTS_GUIDE.md followed
- [ ] All team members credited

### Docker
- [ ] docker-compose.yml tested
- [ ] Multi-stage Dockerfiles
- [ ] Health checks configured
- [ ] Volumes for persistence
- [ ] Images optimized (Alpine)

### CI/CD
- [ ] Pipeline has 5 stages
- [ ] All stages passing
- [ ] Secrets configured
- [ ] Images pushed to Docker Hub
- [ ] Timestamps within exam period

### Testing
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Database tests with PostgreSQL service
- [ ] Security scans completed

### GitHub
- [ ] Repository is public
- [ ] Both team members have commits
- [ ] Commit messages descriptive
- [ ] No large binary files

### Docker Hub
- [ ] Images pushed successfully
- [ ] Tags include: latest, main, SHA
- [ ] Timestamps correct
- [ ] Repositories public

### Screenshots
- [ ] All required screenshots captured
- [ ] Organized in folders
- [ ] High quality and clear
- [ ] Timestamps visible

---

## 🆘 Getting Help

### Resources
- Docker Documentation: https://docs.docker.com/
- Spring Boot: https://spring.io/guides
- React: https://react.dev/
- GitHub Actions: https://docs.github.com/actions

### Quick Commands Reference

```powershell
# Docker
docker-compose up -d        # Start services
docker-compose down         # Stop services
docker-compose ps          # List containers
docker-compose logs -f     # Follow logs
docker-compose restart     # Restart services

# Git
git status                 # Check status
git add .                  # Stage changes
git commit -m "message"    # Commit
git push origin main       # Push to GitHub
git pull origin main       # Pull from GitHub

# Maven
mvn clean package          # Build
mvn test                   # Run tests
mvn spring-boot:run        # Run app

# npm
npm ci                     # Clean install
npm run build              # Build
npm run dev                # Development server
npm test                   # Run tests
```

---

**Time to Complete**: Setup (~15 min) + Testing (~10 min) + Screenshots (~30 min) = **~1 hour**

**Good luck! 🚀**
