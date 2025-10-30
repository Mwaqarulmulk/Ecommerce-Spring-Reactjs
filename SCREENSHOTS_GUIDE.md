# Screenshots Guide for DevOps Lab Submission

**Group-16 | DevOps Lab Midterm Exam**  
**Team Members:** Muhammad Waqar Ul Mulk (FA22-BSE-153), Ghulam Mujtaba (FA22-BSE-199)  
**Date:** October 30, 2025

---

## 📸 Required Screenshots Checklist

This document guides you through capturing all required screenshots for the lab submission.

### ✅ Deliverable 1: GitHub Repository

**Screenshot 1.1 - Repository Overview**
- URL: `https://github.com/<your-username>/Ecommerce-Spring-Reactjs`
- Capture:
  - Repository name
  - README.md preview
  - File structure
  - Recent commits
  - Contributors section showing both team members

**Screenshot 1.2 - Commit History**
- Go to: Insights → Contributors
- Capture:
  - Both team members' contributions
  - Commit counts
  - Lines added/deleted
  - Timeline graph

**Screenshot 1.3 - File Structure**
- Capture the main repository view showing:
  - `.github/workflows/ci-cd.yml`
  - `docker-compose.yml`
  - `ecom-backend/Dockerfile`
  - `ecom-frontend/Dockerfile`
  - `README.md`
  - `devops_report.md`

---

### ✅ Deliverable 2: Working Dockerfiles

**Screenshot 2.1 - Backend Dockerfile**
- File: `ecom-backend/Dockerfile`
- Highlight:
  - Multi-stage build (Stage 1: Build, Stage 2: Runtime)
  - Maven commands
  - Alpine base image
  - EXPOSE 5000

**Screenshot 2.2 - Frontend Dockerfile**
- File: `ecom-frontend/Dockerfile`
- Highlight:
  - Multi-stage build (Stage 1: Build, Stage 2: Nginx)
  - npm ci and npm run build
  - Nginx configuration
  - EXPOSE 80

**Screenshot 2.3 - Docker Compose File**
- File: `docker-compose.yml`
- Highlight:
  - Three services: db, backend, frontend
  - Health checks
  - Volume persistence
  - Internal network
  - Environment variables

---

### ✅ Deliverable 3: CI/CD Pipeline

**Screenshot 3.1 - GitHub Actions Workflow File**
- File: `.github/workflows/ci-cd.yml`
- Capture:
  - All 5 stages visible:
    1. Build & Install
    2. Lint & Security Scan
    3. Test with Database
    4. Build Docker Images
    5. Deploy

**Screenshot 3.2 - Actions Tab - Pipeline Runs**
- Go to: Actions tab in GitHub
- Capture:
  - List of workflow runs
  - **IMPORTANT**: Timestamps within exam period
  - Status (green checkmarks)
  - Branch names (main/develop)
  - Commit messages

**Screenshot 3.3 - Successful Pipeline Run - Overview**
- Click on a successful run
- Capture:
  - All 5 jobs completed successfully
  - Total duration
  - Workflow run number
  - Commit SHA
  - Actor (who triggered it)

**Screenshot 3.4 - Stage 1: Build & Install**
- Expand "Build & Install" job
- Capture:
  - Setup JDK 21
  - Setup Node.js 18
  - Maven build output ("BUILD SUCCESS")
  - npm build output
  - "✓ Backend build successful"
  - "✓ Frontend build successful"

**Screenshot 3.5 - Stage 2: Lint & Security Scan**
- Expand "Lint & Security Scan" job
- Capture:
  - ESLint execution
  - npm audit results
  - Trivy scan results
  - "✓ Linting completed"
  - "✓ Security audit completed"

**Screenshot 3.6 - Stage 3: Test with Database**
- Expand "Test with Database" job
- Capture:
  - PostgreSQL service starting
  - "✓ PostgreSQL is ready"
  - Backend tests running
  - Test results (e.g., "Tests run: X, Failures: 0, Errors: 0")
  - "✓ Backend tests passed"
  - Frontend test results

**Screenshot 3.7 - Stage 4: Build Docker Images**
- Expand "Build Docker Images" job
- Capture:
  - Docker login success
  - Building backend image
  - Building frontend image
  - Pushing to Docker Hub
  - Image digests (SHA256)
  - "✓ Backend Image: ..."
  - "✓ Frontend Image: ..."

**Screenshot 3.8 - Stage 5: Deploy**
- Expand "Deploy to Production" job
- Capture:
  - "=== Deployment Initiated ==="
  - Timestamp
  - Branch and commit info
  - Image tags
  - "=== Ready for Production Deployment ==="
  - Deployment summary artifact

**Screenshot 3.9 - Pipeline Artifacts**
- Scroll down to "Artifacts" section
- Capture:
  - build-artifacts
  - test-reports
  - deployment-report
  - Download buttons

**Screenshot 3.10 - Downloaded Artifact - Deployment Report**
- Download and open `deployment-report/deployment-summary.txt`
- Capture content showing:
  - Deployment date/time
  - Status: SUCCESS
  - Backend and frontend image tags

---

### ✅ Deliverable 4: Running Containers

**Screenshot 4.1 - Docker Compose Up**
- Open PowerShell/Terminal in project root
- Run: `docker-compose up -d --build`
- Capture:
  - Building images
  - Creating containers
  - Starting services
  - "Started" messages

**Screenshot 4.2 - Docker Compose PS**
- Run: `docker-compose ps`
- Capture table showing:
  - ecom-db (Up, healthy)
  - ecom-backend (Up, healthy)
  - ecom-frontend (Up, healthy)
  - Ports (5432, 5000, 80)
  - Status timestamps

**Screenshot 4.3 - Docker Images List**
- Run: `docker images | Select-String "ecom"`
- Capture:
  - ecommerce-spring-reactjs-backend
  - ecommerce-spring-reactjs-frontend
  - postgres:15-alpine
  - Image sizes
  - Created timestamps

**Screenshot 4.4 - Docker Logs - Backend**
- Run: `docker-compose logs backend | Select-Object -Last 50`
- Capture:
  - Spring Boot startup
  - "Started EcommerceApplication"
  - Port 5000
  - Database connection success
  - No errors

**Screenshot 4.5 - Docker Logs - Frontend**
- Run: `docker-compose logs frontend | Select-Object -Last 20`
- Capture:
  - Nginx startup messages
  - Server listening on port 80

**Screenshot 4.6 - Docker Logs - Database**
- Run: `docker-compose logs db | Select-Object -Last 20`
- Capture:
  - PostgreSQL initialization
  - "database system is ready to accept connections"
  - Created database "ecommerce"

**Screenshot 4.7 - Backend Health Check**
- Run: `curl http://localhost:5000/actuator/health`
- Or open in browser: `http://localhost:5000/actuator/health`
- Capture JSON response:
  ```json
  {"status":"UP"}
  ```

**Screenshot 4.8 - Frontend Accessible**
- Open browser: `http://localhost`
- Capture:
  - Application homepage loading
  - React app running
  - Browser address bar showing "localhost"

**Screenshot 4.9 - Docker Network Inspect**
- Run: `docker network inspect ecommerce-spring-reactjs_ecom-network`
- Capture:
  - Network details
  - Connected containers (db, backend, frontend)
  - IP addresses

**Screenshot 4.10 - Docker Volume Inspect**
- Run: `docker volume ls | Select-String "ecom"`
- Capture:
  - db_data volume
  - Created timestamp

---

### ✅ Deliverable 5: Docker Hub Deployment

**Screenshot 5.1 - Docker Hub Login**
- Run: `docker login`
- Capture:
  - "Login Succeeded" message
  - (Hide password/token)

**Screenshot 5.2 - Docker Hub Repository - Backend**
- Go to: `https://hub.docker.com/r/<your-username>/ecom-backend`
- Capture:
  - Repository name
  - Tags (latest, main, SHA tags)
  - **IMPORTANT**: Last pushed timestamp (within exam period)
  - Image size
  - Number of pulls

**Screenshot 5.3 - Docker Hub Repository - Frontend**
- Go to: `https://hub.docker.com/r/<your-username>/ecom-frontend`
- Capture:
  - Repository name
  - Tags (latest, main, SHA tags)
  - Last pushed timestamp
  - Image size

**Screenshot 5.4 - Docker Hub Tags - Backend**
- Click on "Tags" tab for backend repository
- Capture:
  - Multiple tags (latest, main, develop, SHA)
  - Timestamps
  - Digest (SHA256)
  - Compressed size

**Screenshot 5.5 - Docker Hub Tags - Frontend**
- Click on "Tags" tab for frontend repository
- Capture:
  - Tag list
  - Timestamps

**Screenshot 5.6 - Docker Pull Verification**
- Run: `docker pull <your-username>/ecom-backend:latest`
- Capture:
  - Pulling from repository
  - Digest
  - Status: Image is up to date (or Downloaded newer image)

**Screenshot 5.7 - Docker Pull Frontend**
- Run: `docker pull <your-username>/ecom-frontend:latest`
- Capture similar output

---

### ✅ Deliverable 6: GitHub Secrets Configuration

**Screenshot 6.1 - Repository Secrets**
- Go to: Settings → Secrets and variables → Actions
- Capture:
  - DOCKERHUB_USERNAME (hide value)
  - DOCKERHUB_TOKEN (hide value)
  - "2 repository secrets" count
  - Last updated timestamps

**Screenshot 6.2 - Environment Variables (.env.example)**
- Show `.env.example` file content
- Highlight:
  - No hardcoded passwords
  - Placeholder values
  - Clear documentation

---

### ✅ Deliverable 7: Documentation Files

**Screenshot 7.1 - README.md Preview**
- GitHub view of README.md
- Capture:
  - Team member information
  - Tech stack table
  - Architecture diagram (ASCII art)
  - Pipeline overview
  - Setup instructions

**Screenshot 7.2 - devops_report.md Preview**
- GitHub view of devops_report.md
- Capture:
  - Executive summary
  - Technologies used
  - Pipeline design
  - Lessons learned sections

**Screenshot 7.3 - Project Structure**
- Show file tree
- Highlight:
  - .github/workflows/
  - ecom-backend/ (with Dockerfile, pom.xml)
  - ecom-frontend/ (with Dockerfile, package.json)
  - docker-compose.yml
  - Documentation files

---

### ✅ Deliverable 8: Testing Evidence

**Screenshot 8.1 - Local Backend Build**
- Run: `cd ecom-backend; mvn clean package`
- Capture:
  - BUILD SUCCESS
  - Tests run count
  - Time taken

**Screenshot 8.2 - Local Frontend Build**
- Run: `cd ecom-frontend; npm ci; npm run build`
- Capture:
  - Build successful
  - dist/ folder created
  - Bundle size

**Screenshot 8.3 - Backend Tests in CI**
- From GitHub Actions "Test with Database" stage
- Capture:
  - mvn test output
  - Test results summary
  - "Tests run: X, Failures: 0, Errors: 0"

**Screenshot 8.4 - PostgreSQL Service in CI**
- From GitHub Actions workflow
- Capture:
  - PostgreSQL service configuration
  - Health check passing
  - Connection successful

---

### ✅ Deliverable 9: Security Scan Results

**Screenshot 9.1 - npm audit Results**
- From GitHub Actions "Lint & Security Scan"
- Capture:
  - Number of vulnerabilities
  - Severity levels
  - "✓ Security audit completed"

**Screenshot 9.2 - Trivy Scan Results**
- From GitHub Actions
- Capture:
  - Scanning eclipse-temurin:21-jre-alpine
  - Vulnerability count
  - Upload to CodeQL (if enabled)

**Screenshot 9.3 - ESLint Results**
- From GitHub Actions
- Capture:
  - Linting output
  - Files checked
  - Warnings/errors count

---

### ✅ Deliverable 10: Integration Tests

**Screenshot 10.1 - Integration Test File**
- Show: `DatabaseIntegrationTest.java`
- Highlight:
  - @DataJpaTest annotation
  - PostgreSQL connection test
  - CRUD operation tests

**Screenshot 10.2 - Test Configuration**
- Show: `application-test.properties`
- Highlight:
  - Test profile configuration
  - Database URL using environment variables
  - spring.jpa.hibernate.ddl-auto=create-drop

**Screenshot 10.3 - Test Execution Logs**
- From CI/CD or local
- Capture:
  - Test class execution
  - Individual test methods passing
  - Database connection logs

---

## 📋 Quick Capture Commands

### For Windows PowerShell:

```powershell
# 1. Clone and navigate
git clone https://github.com/<your-username>/Ecommerce-Spring-Reactjs.git
cd Ecommerce-Spring-Reactjs

# 2. Build locally
cd ecom-backend
mvn clean package
cd ..

cd ecom-frontend
npm ci
npm run build
cd ..

# 3. Start Docker Compose
docker-compose up -d --build

# 4. Verify containers
docker-compose ps
docker-compose logs backend
docker-compose logs frontend
docker-compose logs db

# 5. Test endpoints
curl http://localhost:5000/actuator/health
curl http://localhost/

# 6. Check images
docker images | Select-String "ecom"

# 7. Check Docker Hub
docker pull <your-username>/ecom-backend:latest
docker pull <your-username>/ecom-frontend:latest

# 8. Clean up
docker-compose down -v
```

---

## 📌 Important Reminders

### Before Capturing Screenshots:

1. ✅ Ensure all team members have commits
2. ✅ Verify timestamps are within exam period
3. ✅ Check all secrets are properly configured
4. ✅ Confirm no hardcoded passwords visible
5. ✅ Run full pipeline at least once
6. ✅ Push images to Docker Hub
7. ✅ Test containers locally

### Screenshot Quality:

- Use high resolution (1920x1080 or higher)
- Capture full window with browser address bar
- Show timestamps clearly
- Include terminal prompts for commands
- Highlight relevant sections
- Use descriptive filenames (e.g., `3.4-stage1-build-install.png`)

### Organization:

Create a folder structure:
```
screenshots/
├── 1-repository/
├── 2-dockerfiles/
├── 3-cicd-pipeline/
├── 4-running-containers/
├── 5-docker-hub/
├── 6-secrets/
├── 7-documentation/
├── 8-testing/
├── 9-security/
└── 10-integration-tests/
```

---

## 🎯 Submission Checklist

Before submitting to Google Classroom:

- [ ] All screenshots captured (50+ screenshots)
- [ ] Screenshots organized in folders
- [ ] README.md includes team information
- [ ] devops_report.md is complete
- [ ] GitHub repository is public
- [ ] All team members have commits
- [ ] CI/CD pipeline passing
- [ ] Docker images on Docker Hub with correct timestamps
- [ ] No hardcoded passwords
- [ ] All documentation files included
- [ ] .env file in .gitignore (not committed)
- [ ] GitHub Classroom submission link provided

---

**Good luck with your submission! 🚀**
