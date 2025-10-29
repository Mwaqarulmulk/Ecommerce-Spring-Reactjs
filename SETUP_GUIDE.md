# 🚀 Step-by-Step Setup Guide

## Prerequisites Installation

### 1. Install Git
- **Windows**: https://git-scm.com/download/win
- **Linux**: `sudo apt install git`
- **Verify**: `git --version`

### 2. Install Docker Desktop
- **Windows/Mac**: https://www.docker.com/products/docker-desktop
- **Linux**: `sudo apt install docker.io docker-compose`
- **Start**: Open Docker Desktop application
- **Verify**: `docker --version` and `docker-compose --version`

### 3. Install Java JDK 21
- Download from: https://www.oracle.com/java/technologies/downloads/#java21
- **Windows**: Run installer, set JAVA_HOME environment variable
- **Linux**: `sudo apt install openjdk-21-jdk`
- **Verify**: `java -version`

### 4. Install Maven
- Download from: https://maven.apache.org/download.cgi
- **Windows**: Extract and add to PATH
- **Linux**: `sudo apt install maven`
- **Verify**: `mvn -version`

### 5. Install Node.js & npm
- Download from: https://nodejs.org/ (LTS 18+)
- **Windows**: Run installer
- **Linux**: `sudo apt install nodejs npm`
- **Verify**: `node -v` and `npm -v`

### 6. Create Docker Hub Account
- Go to: https://hub.docker.com
- Sign up (free account)
- Create access token (Settings → Security → New Access Token)
- Save token securely

---

## Local Testing (WITHOUT Docker)

### Terminal 1: Start Backend

```bash
cd ecom-backend
mvn clean install
mvn spring-boot:run
```

**Expected Output**:
```
Tomcat started on port(s): 5000 (http)
Started EcommerceApplication in 15.234 seconds
```

### Terminal 2: Start Frontend

```bash
cd ecom-frontend
npm install
npm run dev
```

**Expected Output**:
```
  VITE v6.2.0  ready in 234 ms

  ➜  Local:   http://localhost:5173/
  ➜  press h to show help
```

### Access Application

- Frontend: http://localhost:5173
- Backend API: http://localhost:5000
- Backend Health: curl http://localhost:5000/actuator/health

### Stop Services

Press `Ctrl+C` in both terminals

---

## Local Testing WITH Docker Compose

### 1. Create .env File

```bash
cp .env.example .env
```

Edit `.env` and update:
- `POSTGRES_PASSWORD=your_secure_password`
- Keep other values as default

### 2. Build and Start Services

```bash
# From project root
docker-compose up --build

# Or in background
docker-compose up -d --build
```

### 3. Verify Services Are Running

```bash
# Check all containers
docker-compose ps

# Should show:
# NAME           STATUS
# ecom-db        Up (healthy)
# ecom-backend   Up (healthy)
# ecom-frontend  Up (healthy)
```

### 4. Check Service Health

```bash
# Frontend health
curl http://localhost/

# Backend health
curl http://localhost:5000/actuator/health

# Database health
docker-compose exec db pg_isready -U ecomuser
```

### 5. View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### 6. Access Application

- Frontend: http://localhost
- Backend: http://localhost:5000
- Database: localhost:5432

### 7. Stop All Services

```bash
# Stop services (keep volumes)
docker-compose down

# Stop and remove everything (including data)
docker-compose down -v
```

---

## GitHub Setup for CI/CD

### 1. Fork Repository

- Go to: https://github.com/JianquanWang/Ecommerce-Spring-Reactjs
- Click "Fork" (top right)
- Clone to your account

### 2. Clone to Your Machine

```bash
git clone https://github.com/<YOUR-USERNAME>/Ecommerce-Spring-Reactjs.git
cd Ecommerce-Spring-Reactjs
```

### 3. Add GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click "New repository secret"
4. Add these secrets:

**Secret 1: Docker Hub Username**
- Name: `DOCKERHUB_USERNAME`
- Value: Your Docker Hub username

**Secret 2: Docker Hub Token**
- Name: `DOCKERHUB_TOKEN`
- Value: Your Docker Hub access token (generated earlier)

### 4. Enable GitHub Actions

1. Go to **Actions** tab
2. Select "CI-CD Pipeline"
3. Click "Enable workflow"

### 5. Commit and Push

```bash
git add .
git commit -m "Add DevOps pipeline files"
git push origin main
```

### 6. Watch Pipeline Execute

1. Go to **Actions** tab
2. Click on "CI-CD Pipeline" run
3. Watch stages execute in real-time
4. Check logs for any errors

---

## Verifying Pipeline Success

### Check Pipeline Status

1. Go to Actions → Latest run
2. All 5 stages should be green (✅):
   - ✅ Build & Install
   - ✅ Lint & Security Scan
   - ✅ Test with Database
   - ✅ Build Docker Images
   - ✅ Deploy

### Download Artifacts

1. Click on workflow run
2. Scroll to "Artifacts"
3. Download:
   - `build-artifacts`
   - `test-reports`
   - `deployment-report`

### Check Docker Hub

1. Go to https://docker.io/dashboard
2. Repositories should show:
   - `your-username/ecom-backend:latest`
   - `your-username/ecom-frontend:latest`
   - `your-username/ecom-backend:main-<SHA>`
   - `your-username/ecom-frontend:main-<SHA>`

---

## Lab Submission Checklist

### Files to Verify

```
✅ .github/workflows/ci-cd.yml          # Pipeline definition
✅ ecom-backend/Dockerfile              # Backend container
✅ ecom-frontend/Dockerfile             # Frontend container
✅ ecom-frontend/nginx.conf             # Web server config
✅ docker-compose.yml                   # Orchestration
✅ .env.example                         # Secrets template
✅ .gitignore                           # Updated
✅ README.md                            # Documentation
✅ devops_report.md                     # DevOps report
```

### Screenshots to Capture

1. **Working Pipeline**
   - Go to Actions → Latest run
   - Screenshot all 5 stages passing
   - Screenshot "Deployment successful" message

2. **Running Containers**
   ```bash
   docker-compose ps
   # Screenshot output
   ```

3. **Service Health**
   ```bash
   curl http://localhost/
   curl http://localhost:5000/actuator/health
   # Screenshot both responses
   ```

4. **Docker Images on Hub**
   - Go to https://docker.io/dashboard
   - Screenshot repositories list

5. **GitHub Secrets Setup**
   - Go to Settings → Secrets
   - Screenshot (blur token values)

### Submission Folder Structure

```
submission/
├── 00_Prerequisites_Installed.md
├── 01_Local_Testing_Success.md
├── 02_GitHub_Pipeline_Screenshots/
│   ├── pipeline-passing.png
│   ├── all-stages-green.png
│   ├── test-results.png
│   └── docker-hub-images.png
├── 03_Running_Containers/
│   ├── docker-compose-ps.txt
│   ├── container-health.txt
│   └── service-logs.txt
├── 04_Code_Screenshots/
│   ├── dockerfile-backend.png
│   ├── dockerfile-frontend.png
│   ├── docker-compose.yml.png
│   └── ci-cd-workflow.png
├── Repository_Link.txt
└── README.md
```

---

## Troubleshooting

### Docker Not Starting

```bash
# Windows/Mac
- Open Docker Desktop
- Wait for "Docker Engine running"

# Linux
sudo systemctl start docker
docker ps  # Should not error
```

### Port Already in Use

```bash
# Check what''s using port 5000 (backend)
lsof -i :5000
# Kill process
kill -9 <PID>

# Same for 5173 (frontend), 80 (nginx), 5432 (database)
```

### PostgreSQL Connection Failed

```bash
# Check container is healthy
docker-compose ps

# If not healthy, check logs
docker-compose logs db

# Restart services
docker-compose restart db
```

### Maven Build Fails

```bash
# Clear cache
mvn clean

# Rebuild
mvn clean install

# Check Java version
java -version  # Should be 21+
```

### Node_modules Issues

```bash
# Remove and reinstall
rm -rf ecom-frontend/node_modules
npm install
```

### GitHub Actions Fails

Check logs:
1. Go to Actions
2. Click failing run
3. Click failing job
4. Scroll to see error messages

Common issues:
- Secrets not set (check Settings → Secrets)
- Java version mismatch (needs 21)
- Docker Hub login failed (check token)

---

## Success Indicators

✅ **Local Development**
- `docker-compose up --build` completes without errors
- All 3 containers show as "Up (healthy)"
- Frontend accessible at http://localhost
- Backend health check returns 200

✅ **GitHub Actions Pipeline**
- All 5 stages complete with green checkmarks
- Tests pass with 0 failures
- Docker images pushed to Docker Hub
- No security vulnerabilities flagged

✅ **Documentation**
- README.md clearly explains the project
- devops_report.md documents all decisions
- Code is commented and clean
- No hardcoded secrets in repository

---

## Next Steps After Successful Submission

1. **Production Deployment**
   - Deploy to Render, Railway, or AWS
   - Set up monitoring and logging
   - Configure auto-scaling

2. **Advanced Features**
   - Add Kubernetes manifests
   - Implement blue-green deployment
   - Add Helm charts

3. **Performance**
   - Load testing with Apache JMeter
   - Database query optimization
   - CDN integration for frontend

4. **Security**
   - Implement OWASP checks
   - Add rate limiting
   - SSL/TLS certificates

---

For help: Check README.md and devops_report.md in the repository!
