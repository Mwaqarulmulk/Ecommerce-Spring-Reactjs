# 📋 DevOps Lab Midterm - Submission Checklist

**Group-16** | Muhammad Waqar Ul Mulk (FA22-BSE-153), Ghulam Mujtaba (FA22-BSE-199)  
**Submission Deadline**: [Add your deadline]  
**Course**: DevOps for Cloud Computing

---

## ✅ Pre-Submission Requirements

### 1. Team Contributions ✓

- [ ] **Both team members have visible commits**
  - Check: GitHub → Insights → Contributors
  - Requirement: Both names should appear with commits
  - Target: At least 5 commits each

- [ ] **Commit messages are descriptive**
  - ✅ Good: "Add integration tests for database operations"
  - ❌ Bad: "update", "fix", "changes"

- [ ] **Commits distributed across project**
  - Backend commits
  - Frontend commits
  - CI/CD configuration
  - Documentation

### 2. Hardcoded Passwords Check ✓

- [ ] **No passwords in source code**
  ```powershell
  # Search for potential hardcoded secrets
  git grep -i "password.*=" -- "*.java" "*.js" "*.properties" "*.yml"
  git grep -i "secret.*=" -- "*.java" "*.js" "*.properties" "*.yml"
  ```

- [ ] **.env file NOT in repository**
  ```powershell
  git log --all --full-history -- .env
  # Should show nothing
  ```

- [ ] **application.properties uses environment variables**
  - Check: `${POSTGRES_PASSWORD}` format
  - No: `password=hardcoded123`

- [ ] **.gitignore includes .env**
  ```powershell
  cat .gitignore | Select-String ".env"
  ```

### 3. Timestamps Verification ✓

- [ ] **CI/CD logs within exam period**
  - GitHub Actions → Latest workflow run
  - Check timestamp: Should be during exam
  - Capture screenshot with timestamp

- [ ] **Docker Hub images within exam period**
  - Docker Hub → Repository → Tags
  - Check "Last pushed" timestamp
  - Must be during exam period

- [ ] **Git commits within exam period**
  ```powershell
  git log --since="2025-10-30" --until="2025-10-31" --oneline
  ```

---

## 📦 Deliverable 1: Public GitHub Repository

### Repository Structure ✓

- [ ] **Repository is public**
  - Settings → Danger Zone → Change visibility → Public

- [ ] **Repository name is descriptive**
  - ✅ Good: `Ecommerce-Spring-Reactjs`
  - ❌ Bad: `project`, `assignment`

- [ ] **README.md exists and is complete**
  - [ ] Team member information
  - [ ] Tech stack table
  - [ ] Prerequisites section
  - [ ] Setup instructions
  - [ ] Docker commands
  - [ ] CI/CD pipeline description
  - [ ] Architecture diagram

- [ ] **All required files present**
  ```
  ✓ .github/workflows/ci-cd.yml
  ✓ ecom-backend/Dockerfile
  ✓ ecom-backend/pom.xml
  ✓ ecom-backend/src/test/
  ✓ ecom-frontend/Dockerfile
  ✓ ecom-frontend/package.json
  ✓ docker-compose.yml
  ✓ .env.example
  ✓ .gitignore
  ✓ README.md
  ✓ devops_report.md
  ```

### Repository Quality ✓

- [ ] **No unnecessary files**
  - No: node_modules/
  - No: target/
  - No: .env
  - No: IDE config (.vscode/, .idea/)
  - No: Large binary files

- [ ] **Clean commit history**
  ```powershell
  git log --oneline --graph --all
  ```

---

## 🐳 Deliverable 2: Dockerfiles and docker-compose.yml

### Backend Dockerfile ✓

- [ ] **Multi-stage build implemented**
  - Stage 1: Build (Maven + JDK)
  - Stage 2: Runtime (JRE only)

- [ ] **Uses Alpine base image**
  - `eclipse-temurin:21-jre-alpine`

- [ ] **Proper EXPOSE directive**
  - `EXPOSE 5000`

- [ ] **Health check configured**
  ```dockerfile
  HEALTHCHECK --interval=30s --timeout=10s ...
  ```

- [ ] **Build successful locally**
  ```powershell
  docker build -f ecom-backend/Dockerfile -t test-backend .
  docker run -d -p 5000:5000 test-backend
  curl http://localhost:5000/actuator/health
  ```

### Frontend Dockerfile ✓

- [ ] **Multi-stage build implemented**
  - Stage 1: Build (Node.js + npm)
  - Stage 2: Serve (Nginx)

- [ ] **Uses Alpine images**
  - Build: `node:18-alpine`
  - Serve: `nginx:alpine`

- [ ] **Nginx config included**
  - `COPY nginx.conf`

- [ ] **Proper EXPOSE directive**
  - `EXPOSE 80`

- [ ] **Build successful locally**
  ```powershell
  docker build -f ecom-frontend/Dockerfile -t test-frontend .
  docker run -d -p 8080:80 test-frontend
  curl http://localhost:8080
  ```

### docker-compose.yml ✓

- [ ] **All 3 services defined**
  - `db` (PostgreSQL)
  - `backend` (Spring Boot)
  - `frontend` (React + Nginx)

- [ ] **Internal network configured**
  ```yaml
  networks:
    ecom-network:
      driver: bridge
  ```

- [ ] **Services on same network**
  - All services: `networks: - ecom-network`

- [ ] **Persistent database volume**
  ```yaml
  volumes:
    db_data:
      driver: local
  ```

- [ ] **Health checks for all services**
  - db: `pg_isready`
  - backend: `wget http://localhost:5000/actuator/health`
  - frontend: `wget http://localhost/`

- [ ] **Dependency management**
  ```yaml
  backend:
    depends_on:
      db:
        condition: service_healthy
  ```

- [ ] **Environment variables from .env**
  - No hardcoded values
  - Uses: `${POSTGRES_PASSWORD:-changeme}`

- [ ] **Works locally**
  ```powershell
  docker-compose up -d --build
  docker-compose ps  # All should be "Up (healthy)"
  docker-compose down -v
  ```

---

## 🔄 Deliverable 3: CI/CD Pipeline YAML

### Pipeline Structure ✓

- [ ] **5 stages implemented**
  1. ✓ Build & Install
  2. ✓ Lint & Security Scan
  3. ✓ Test with Database
  4. ✓ Build Docker Images
  5. ✓ Deploy (Conditional)

- [ ] **Workflow file location correct**
  - `.github/workflows/ci-cd.yml`

- [ ] **Triggers configured**
  ```yaml
  on:
    push:
      branches: [ main, develop ]
    pull_request:
      branches: [ main ]
  ```

### Stage 1: Build & Install ✓

- [ ] **JDK 21 setup**
  ```yaml
  - uses: actions/setup-java@v4
    with:
      java-version: '21'
      distribution: 'temurin'
  ```

- [ ] **Node.js 18 setup**
  ```yaml
  - uses: actions/setup-node@v4
    with:
      node-version: '18'
  ```

- [ ] **Maven build**
  ```yaml
  run: mvn -B clean package -DskipTests
  ```

- [ ] **npm build**
  ```yaml
  run: npm ci && npm run build
  ```

- [ ] **Artifacts uploaded**
  ```yaml
  - uses: actions/upload-artifact@v3
  ```

### Stage 2: Lint & Security Scan ✓

- [ ] **ESLint configured**
  ```yaml
  run: npm run lint
  ```

- [ ] **npm audit**
  ```yaml
  run: npm audit --audit-level=moderate
  ```

- [ ] **Trivy scan**
  ```yaml
  - uses: aquasecurity/trivy-action@master
  ```

### Stage 3: Test with Database ✓

- [ ] **PostgreSQL service configured**
  ```yaml
  services:
    postgres:
      image: postgres:15-alpine
      env:
        POSTGRES_DB: ecommerce
        POSTGRES_USER: ecomuser
        POSTGRES_PASSWORD: changeme
      options: >-
        --health-cmd pg_isready
        --health-interval 10s
  ```

- [ ] **Backend tests run**
  ```yaml
  run: mvn test
  ```

- [ ] **Frontend tests run**
  ```yaml
  run: npm test -- --watchAll=false
  ```

- [ ] **Test reports uploaded**

### Stage 4: Build Docker Images ✓

- [ ] **Docker Buildx setup**
  ```yaml
  - uses: docker/setup-buildx-action@v2
  ```

- [ ] **Docker Hub login**
  ```yaml
  - uses: docker/login-action@v2
    with:
      username: ${{ secrets.DOCKERHUB_USERNAME }}
      password: ${{ secrets.DOCKERHUB_TOKEN }}
  ```

- [ ] **Backend image built and pushed**
  ```yaml
  - uses: docker/build-push-action@v4
    with:
      push: true
      tags: ${{ secrets.DOCKERHUB_USERNAME }}/ecom-backend:latest
  ```

- [ ] **Frontend image built and pushed**

- [ ] **Multiple tags applied**
  - `latest` (main branch only)
  - `branch-name`
  - `sha-{commit}`

### Stage 5: Deploy ✓

- [ ] **Conditional execution**
  ```yaml
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  ```

- [ ] **Deployment logs shown**
  ```yaml
  run: echo "Deployed images: ..."
  ```

- [ ] **Deployment summary generated**

### Pipeline Execution ✓

- [ ] **Pipeline passes successfully**
  - Check: GitHub → Actions → All jobs green

- [ ] **All stages complete**
  - No skipped stages (except Deploy on non-main)

- [ ] **No warnings about secrets**
  - Secrets properly masked in logs

- [ ] **Total duration reasonable**
  - Target: < 40 minutes

---

## 📸 Deliverable 4: Screenshots

### Required Screenshots ✓

Create folder: `screenshots/`

- [ ] **1. Repository Overview** (5 screenshots)
  - 1.1 Main page with README
  - 1.2 File structure
  - 1.3 Commit history
  - 1.4 Contributors graph
  - 1.5 Repository settings (showing public)

- [ ] **2. Dockerfiles** (3 screenshots)
  - 2.1 Backend Dockerfile content
  - 2.2 Frontend Dockerfile content
  - 2.3 docker-compose.yml content

- [ ] **3. CI/CD Pipeline** (10+ screenshots)
  - 3.1 Workflow file (.github/workflows/ci-cd.yml)
  - 3.2 Actions tab - workflow runs list
  - 3.3 Successful run - overview
  - 3.4 Stage 1 logs
  - 3.5 Stage 2 logs
  - 3.6 Stage 3 logs
  - 3.7 Stage 4 logs
  - 3.8 Stage 5 logs
  - 3.9 Pipeline artifacts
  - 3.10 Deployment summary

- [ ] **4. Running Containers** (10 screenshots)
  - 4.1 docker-compose up output
  - 4.2 docker-compose ps (all healthy)
  - 4.3 docker images list
  - 4.4 Backend logs
  - 4.5 Frontend logs
  - 4.6 Database logs
  - 4.7 Backend health check
  - 4.8 Frontend in browser
  - 4.9 Docker network inspect
  - 4.10 Docker volume list

- [ ] **5. Docker Hub** (7 screenshots)
  - 5.1 Docker Hub login
  - 5.2 Backend repository overview
  - 5.3 Frontend repository overview
  - 5.4 Backend tags list
  - 5.5 Frontend tags list
  - 5.6 Pull backend image
  - 5.7 Pull frontend image

- [ ] **6. GitHub Secrets** (2 screenshots)
  - 6.1 Secrets page (values hidden)
  - 6.2 .env.example file

- [ ] **7. Documentation** (3 screenshots)
  - 7.1 README.md preview
  - 7.2 devops_report.md preview
  - 7.3 File structure tree

- [ ] **8. Testing** (4 screenshots)
  - 8.1 Local backend build
  - 8.2 Local frontend build
  - 8.3 CI test stage logs
  - 8.4 Test reports

- [ ] **9. Security** (3 screenshots)
  - 9.1 npm audit results
  - 9.2 Trivy scan results
  - 9.3 ESLint results

- [ ] **10. Integration Tests** (3 screenshots)
  - 10.1 Integration test file
  - 10.2 Test configuration
  - 10.3 Test execution logs

### Screenshot Quality ✓

- [ ] **High resolution**
  - Minimum: 1920x1080
  - Format: PNG or JPG

- [ ] **Proper naming**
  - Format: `{number}-{description}.png`
  - Example: `3.4-stage1-build-install.png`

- [ ] **Timestamps visible**
  - CI/CD timestamps
  - Docker Hub timestamps
  - Git commit timestamps

- [ ] **Organized in folders**
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

## 📄 Deliverable 5: Documentation

### README.md ✓

- [ ] **Project title and description**
- [ ] **Team member information**
  - Names
  - Registration IDs
  - GitHub profiles
- [ ] **Tech stack table**
- [ ] **Prerequisites list**
- [ ] **Installation instructions**
- [ ] **Docker Compose instructions**
- [ ] **CI/CD pipeline overview**
- [ ] **Architecture diagram** (ASCII art acceptable)
- [ ] **Testing instructions**
- [ ] **Troubleshooting section**
- [ ] **License/Academic statement**

### devops_report.md ✓

- [ ] **Executive Summary**
- [ ] **Technologies Used** (detailed table)
- [ ] **Architecture & Pipeline Design**
  - System architecture diagram
  - Pipeline flow diagram
- [ ] **Secret Management Strategy**
  - How secrets are handled
  - GitHub Secrets configuration
  - Environment variables
- [ ] **Testing Process**
  - Unit tests
  - Integration tests
  - Database testing
  - Security scanning
- [ ] **Lessons Learned**
  - Technical insights
  - Challenges faced
  - Solutions implemented
  - Best practices applied
- [ ] **Performance Metrics**
  - Build times
  - Image sizes
  - Resource usage
- [ ] **Deployment & Production Readiness**
- [ ] **Recommendations**

### Additional Documentation ✓

- [ ] **.env.example file**
  - All required variables
  - Clear descriptions
  - No actual secrets

- [ ] **SCREENSHOTS_GUIDE.md** (optional but helpful)
- [ ] **QUICK_START.md** (optional but helpful)

---

## 🚀 Final Verification

### Local Testing ✓

```powershell
# Complete test run
cd Ecommerce-Spring-Reactjs

# 1. Clean start
docker-compose down -v

# 2. Build and start
docker-compose up -d --build

# 3. Wait for services
Start-Sleep -Seconds 30

# 4. Verify all healthy
docker-compose ps

# 5. Test endpoints
curl http://localhost/
curl http://localhost:5000/actuator/health

# 6. Check logs (no errors)
docker-compose logs backend | Select-String "error" -CaseSensitive
docker-compose logs frontend | Select-String "error" -CaseSensitive

# 7. Verify database
docker-compose exec db psql -U ecomuser -d ecommerce -c "\dt"

# 8. Clean up
docker-compose down -v
```

### CI/CD Verification ✓

- [ ] **Trigger fresh pipeline run**
  ```powershell
  git commit --allow-empty -m "Final verification run"
  git push origin main
  ```

- [ ] **All 5 stages pass**
  - Wait ~30-40 minutes
  - Check: GitHub → Actions

- [ ] **Images pushed to Docker Hub**
  - Check: hub.docker.com
  - Verify timestamps

- [ ] **Deployment stage runs (main branch)**

### Docker Hub Verification ✓

- [ ] **Backend image available**
  ```powershell
  docker pull <username>/ecom-backend:latest
  ```

- [ ] **Frontend image available**
  ```powershell
  docker pull <username>/ecom-frontend:latest
  ```

- [ ] **Tags correct**
  - `latest` on main branch
  - SHA tags present
  - Branch tags present

### Security Verification ✓

- [ ] **No secrets in repository**
  ```powershell
  # Search for common secret patterns
  git grep -E "password.*=.*['\"].*['\"]" -- "*.properties" "*.yml" "*.java"
  git grep -E "token.*=.*['\"].*['\"]" -- "*.properties" "*.yml" "*.java"
  git grep -E "secret.*=.*['\"].*['\"]" -- "*.properties" "*.yml" "*.java"
  ```

- [ ] **.env not in git history**
  ```powershell
  git log --all --full-history --source --pretty=format:"%H %s" -- .env
  ```

- [ ] **GitHub Secrets configured**
  - DOCKERHUB_USERNAME
  - DOCKERHUB_TOKEN

---

## 📤 Submission Package

### Create Submission ZIP ✓

```powershell
# Create submission folder
New-Item -ItemType Directory -Force -Path "Submission-Group16"

# Copy repository (without .git)
Copy-Item -Recurse -Exclude ".git","node_modules","target" `
  "Ecommerce-Spring-Reactjs\*" "Submission-Group16\code\"

# Copy screenshots
Copy-Item -Recurse "screenshots" "Submission-Group16\screenshots\"

# Create submission info
@"
DevOps Lab Midterm Submission
Group-16
Muhammad Waqar Ul Mulk (FA22-BSE-153)
Ghulam Mujtaba (FA22-BSE-199)

GitHub Repository: https://github.com/<your-username>/Ecommerce-Spring-Reactjs
Docker Hub: https://hub.docker.com/u/<your-username>

Submission Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
"@ | Out-File "Submission-Group16\README.txt"

# Create ZIP
Compress-Archive -Path "Submission-Group16\*" -DestinationPath "Group16-DevOps-Midterm.zip"
```

### Submission Contents ✓

```
Group16-DevOps-Midterm.zip
├── code/
│   ├── .github/workflows/ci-cd.yml
│   ├── ecom-backend/
│   ├── ecom-frontend/
│   ├── docker-compose.yml
│   ├── README.md
│   ├── devops_report.md
│   └── ...
├── screenshots/
│   ├── 1-repository/
│   ├── 2-dockerfiles/
│   ├── 3-cicd-pipeline/
│   └── ...
└── README.txt (submission info)
```

### Google Classroom Submission ✓

- [ ] **Submit ZIP file**
- [ ] **Include GitHub repository link**
- [ ] **Include Docker Hub profile link**
- [ ] **Include team member names**
- [ ] **Submit before deadline**

---

## 🎯 Grading Criteria Self-Check

| Criteria | Points | Status | Notes |
|----------|--------|--------|-------|
| **Containerization** | 5 | ☐ | Multi-stage builds, compose file |
| **CI/CD Pipeline** | 8 | ☐ | All 5 stages functional |
| **Testing** | 4 | ☐ | Unit + integration tests |
| **Security** | 3 | ☐ | No hardcoded secrets |
| **Documentation** | 3 | ☐ | README + report complete |
| **Deployment** | 2 | ☐ | Images on Docker Hub |
| **Total** | 25 | - | - |

### Deductions to Avoid (-10 marks each) ✓

- [ ] ❌ **NO hardcoded passwords**
- [ ] ❌ **NO reused prior submissions**
- [ ] ❌ **CI/CD logs timestamped correctly**
- [ ] ❌ **Both members have contributions**

---

## ✨ Bonus Points (Optional)

- [ ] **Advanced Features**
  - Kubernetes deployment files
  - Monitoring setup (Prometheus/Grafana)
  - Automated rollback mechanism
  - Performance benchmarks

- [ ] **Extra Documentation**
  - Video demonstration
  - Architecture diagrams (draw.io)
  - API documentation (Swagger)
  - Database schema diagram

- [ ] **Code Quality**
  - High test coverage (>80%)
  - Code quality metrics
  - Performance optimization
  - Clean code principles

---

## 🏁 Final Checklist

**30 Minutes Before Submission:**

- [ ] ✅ All tests passing locally
- [ ] ✅ All tests passing in CI/CD
- [ ] ✅ Docker images on Docker Hub
- [ ] ✅ Screenshots organized and complete
- [ ] ✅ Documentation reviewed
- [ ] ✅ No hardcoded secrets
- [ ] ✅ Both members have commits
- [ ] ✅ Repository is public
- [ ] ✅ Submission ZIP created
- [ ] ✅ Google Classroom ready

**Submit and Verify:**

- [ ] ✅ ZIP file uploaded
- [ ] ✅ Confirmation received
- [ ] ✅ Links accessible (test in incognito)
- [ ] ✅ Team members notified

---

**Submission Complete! 🎉**

**Submitted by:**
- Muhammad Waqar Ul Mulk (FA22-BSE-153)
- Ghulam Mujtaba (FA22-BSE-199)

**Date:** _______________  
**Time:** _______________  
**Confirmation #:** _______________

---

**Good Luck! 🚀**
