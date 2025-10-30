# E-Commerce Full Stack Application - DevOps Ready

**Group-16 | DevOps Lab Midterm Exam**

👥 **Team Members:**
- **MUHAMMAD WAQAR UL MULK** (FA22-BSE-153)
- **GHULAM MUJTABA** (FA22-BSE-199)

📌 **GitHub Profile:** [ghulam-mujtaba5](https://github.com/ghulam-mujtaba5)

---

A modern full-stack e-commerce platform built with **Spring Boot 3.4** (Backend) and **React 19** (Frontend), fully containerized with Docker and automated CI/CD pipeline using GitHub Actions.

## � QUICK START (For Submission)

**⚡ Need to submit quickly? Start here:**

1. **Read First:** [`IMPLEMENTATION_COMPLETE.md`](IMPLEMENTATION_COMPLETE.md) - What we've done
2. **Quick Setup:** [`EXPRESS_GUIDE.md`](EXPRESS_GUIDE.md) - 30-minute submission guide
3. **Verify Ready:** Run `.\verify-submission.ps1` - Automated checks
4. **Screenshots:** [`SCREENSHOTS_GUIDE.md`](SCREENSHOTS_GUIDE.md) - What to capture
5. **Final Check:** [`SUBMISSION_CHECKLIST.md`](SUBMISSION_CHECKLIST.md) - Before submitting

**Everything is ready! Just configure GitHub Secrets and push to trigger CI/CD.**

---

## �📋 Table of Contents

- [Quick Start (For Submission)](#-quick-start-for-submission)
- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Local Development](#local-development)
- [Docker & Containerization](#docker--containerization)
- [CI/CD Pipeline](#cicd-pipeline)
- [Deployment](#deployment)
- [Complete Documentation](#-complete-documentation)
- [Contributing](#contributing)
- [License](#license)

---

## 📌 Project Overview

This project demonstrates a production-ready DevOps workflow for a full-stack e-commerce application:

- **Backend**: Spring Boot REST API with PostgreSQL database
- **Frontend**: React SPA with Vite bundler
- **Database**: PostgreSQL with persistent volumes
- **Containerization**: Multi-stage Docker builds for both services
- **Orchestration**: Docker Compose for local development
- **CI/CD**: GitHub Actions with 5-stage pipeline (Build, Lint, Test, Docker Build, Deploy)
- **Security**: JWT authentication, environment-based secrets management

---

## 🛠 Tech Stack

### Backend
- **Language**: Java 21
- **Framework**: Spring Boot 3.4.3
- **Build Tool**: Maven 3.9
- **ORM**: JPA/Hibernate
- **Database**: PostgreSQL 15
- **Authentication**: JWT (JJWT 0.12.3)
- **Testing**: Spring Boot Test (JUnit)

### Frontend
- **Language**: JavaScript (ES Modules)
- **Framework**: React 19.0.0
- **Build Tool**: Vite 6.2.0
- **State Management**: Redux Toolkit
- **UI Library**: Material-UI 7.0.1
- **Styling**: Tailwind CSS 4.1.2
- **HTTP Client**: Axios 1.8.4
- **Routing**: React Router DOM

### DevOps & Infrastructure
- **Containerization**: Docker & Docker Compose
- **CI/CD**: GitHub Actions
- **Registry**: Docker Hub
- **Web Server**: Nginx (Alpine)
- **Database**: PostgreSQL (Alpine)

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

### Essential
- [Git](https://git-scm.com/downloads) - Version control
- [Docker Desktop](https://www.docker.com/products/docker-desktop) - Containerization (includes Docker Compose)
- [Java JDK 21](https://www.oracle.com/java/technologies/downloads/#java21) - Backend runtime
- [Maven 3.9+](https://maven.apache.org/download.cgi) - Java build tool
- [Node.js LTS 18+](https://nodejs.org/) - Frontend runtime
- [VS Code](https://code.visualstudio.com/) - Code editor

### Recommended VS Code Extensions
- **Docker** - ms-azuretools.vscode-docker
- **Remote - Containers** - ms-vscode-remote.remote-containers
- **Java Extension Pack** - vscjava.vscode-java-pack
- **Spring Boot Extension Pack** - Pivotal.vscode-spring-boot
- **ESLint** - dbaeumer.vscode-eslint
- **Prettier** - esbenp.prettier-vscode

### Optional
- [PostgreSQL Client](https://www.postgresql.org/download/) - Database debugging
- [GitHub CLI](https://cli.github.com/) - GitHub integration
- [Trivy](https://github.com/aquasecurity/trivy) - Container vulnerability scanning

---

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci-cd.yml              # GitHub Actions CI/CD pipeline
├── ecom-backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/              # Backend source code
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/
│   ├── pom.xml                    # Maven configuration
│   ├── mvnw                       # Maven wrapper (Windows)
│   ├── mvnw.cmd                   # Maven wrapper script
│   └── Dockerfile                 # Multi-stage backend build
├── ecom-frontend/
│   ├── src/
│   │   ├── main.jsx               # React entry point
│   │   ├── App.jsx                # Root component
│   │   └── ...
│   ├── public/                    # Static assets
│   ├── package.json               # npm configuration
│   ├── vite.config.js             # Vite bundler config
│   ├── nginx.conf                 # Nginx reverse proxy config
│   ├── Dockerfile                 # Multi-stage frontend build
│   └── .env                       # Frontend environment variables
├── docker-compose.yml             # Local development orchestration
├── .env.example                   # Environment variables template
├── .gitignore                     # Git ignore rules
├── README.md                      # This file
└── devops_report.md               # DevOps implementation report
```

---

## 🚀 Local Development

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/Ecommerce-Spring-Reactjs.git
cd Ecommerce-Spring-Reactjs
```

### 2. Set Up Environment Variables

```bash
cp .env.example .env
```

Edit `.env` and update (if needed):
- `POSTGRES_PASSWORD`
- `DOCKERHUB_USERNAME` (for CI/CD)
- `DOCKERHUB_TOKEN` (for CI/CD)

### 3. Backend Setup (Manual)

```bash
cd ecom-backend

# Install dependencies
mvn clean install

# Run application
mvn spring-boot:run
# Runs on http://localhost:5000
```

### 4. Frontend Setup (Manual)

```bash
cd ecom-frontend

# Install dependencies
npm install

# Development server
npm run dev
# Runs on http://localhost:5173

# Build for production
npm run build

# Lint check
npm run lint
```

### 5. Testing Locally

```bash
# Backend tests
cd ecom-backend && mvn test

# Frontend tests
cd ecom-frontend && npm test -- --watchAll=false
```

---

## 🐳 Docker & Containerization

### Why Docker?

- **Consistency**: Same environment across dev, test, and production
- **Isolation**: Services don't interfere with each other
- **Scalability**: Easy to scale services horizontally
- **Multi-stage Builds**: Optimized image sizes for production

### Local Docker Execution

#### 1. Build and Run All Services

```bash
# From project root
docker-compose up --build

# Detached mode
docker-compose up -d --build
```

#### 2. Verify Services

```bash
# Check running containers
docker-compose ps

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

#### 3. Access Services

- **Frontend**: http://localhost:80
- **Backend API**: http://localhost:5000
- **Database**: localhost:5432 (psql or GUI)

#### 4. Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Image Details

#### Backend Image
- **Base Image**: `eclipse-temurin:21-jre-alpine`
- **Size**: ~400MB (optimized with JRE-only)
- **Port**: 5000
- **Health Check**: Spring Boot actuator endpoint

#### Frontend Image
- **Base Image**: `nginx:alpine`
- **Size**: ~150MB
- **Port**: 80
- **Features**: Gzip compression, caching, SPA routing

#### Database Image
- **Base Image**: `postgres:15-alpine`
- **Size**: ~250MB
- **Volume**: `db_data` (persistent)
- **Port**: 5432

---

## 🔄 CI/CD Pipeline

### Pipeline Overview

The GitHub Actions workflow includes **5 stages**:

```
┌─────────────────────────────────────────────────────────┐
│ Stage 1: Build & Install (Java 21 + Node 18)           │
│ ├─ Checkout code                                        │
│ ├─ Build Backend (Maven clean package)                  │
│ └─ Build Frontend (npm ci && npm run build)             │
├─────────────────────────────────────────────────────────┤
│ Stage 2: Lint & Security Scan                          │
│ ├─ ESLint Frontend                                      │
│ ├─ npm audit security check                             │
│ └─ Trivy base image vulnerability scan                  │
├─────────────────────────────────────────────────────────┤
│ Stage 3: Test with Database                            │
│ ├─ PostgreSQL service (GitHub Actions)                  │
│ ├─ Backend tests (JUnit with DB)                        │
│ └─ Frontend tests (Jest/Vitest)                         │
├─────────────────────────────────────────────────────────┤
│ Stage 4: Build Docker Images                           │
│ ├─ Build Backend image (multi-stage)                    │
│ ├─ Build Frontend image (multi-stage)                   │
│ └─ Push to Docker Hub                                   │
├─────────────────────────────────────────────────────────┤
│ Stage 5: Deploy (Conditional - main branch only)       │
│ └─ Generate deployment summary                          │
└─────────────────────────────────────────────────────────┘
```

### Setting Up GitHub Actions

#### 1. Fork/Clone the Repository

```bash
git clone https://github.com/<your-username>/Ecommerce-Spring-Reactjs.git
cd Ecommerce-Spring-Reactjs
git remote set-url origin https://github.com/<your-username>/Ecommerce-Spring-Reactjs.git
```

#### 2. Create Docker Hub Secrets

Go to GitHub Repository → Settings → Secrets and variables → Actions

Add these secrets:

| Secret Name | Value |
|---|---|
| `DOCKERHUB_USERNAME` | Your Docker Hub username |
| `DOCKERHUB_TOKEN` | Your Docker Hub access token |

**Generate Docker Hub Token**:
1. Go to [Docker Hub](https://hub.docker.com/)
2. Account Settings → Security → New Access Token
3. Copy and add to GitHub Secrets

#### 3. Enable GitHub Actions

- Go to Actions tab
- Select "CI-CD Pipeline"
- Click "Enable"

#### 4. Push Code to Trigger Pipeline

```bash
git add .
git commit -m "Add DevOps pipeline"
git push origin main
```

### Monitoring Pipeline

1. Go to your GitHub repository → **Actions** tab
2. View real-time pipeline execution
3. Check logs for each stage
4. Download artifacts (test reports, deployment summary)

### Pipeline Artifacts

After successful run, download:
- `build-artifacts/` - Compiled JAR and frontend dist
- `test-reports/` - Backend and frontend test results
- `deployment-report/` - Deployment summary

---

## 🚢 Deployment

### Local Docker Compose Deployment

```bash
# Create .env file
cp .env.example .env

# Start all services
docker-compose up -d

# Verify health
docker-compose ps

# Check logs
docker-compose logs -f
```

### Docker Hub Deployment

Once images are pushed to Docker Hub:

```bash
# Pull images
docker pull your_username/ecom-backend:latest
docker pull your_username/ecom-frontend:latest

# Run with docker-compose
docker-compose up -d
```

### Cloud Deployment (Render/Railway)

**Example for Render.com**:

1. Connect GitHub repository
2. Create services:
   - Backend (Docker service)
   - Frontend (Static site or Docker)
   - PostgreSQL (Render managed database)
3. Set environment variables
4. Deploy

---

## 🔐 Security Best Practices

### Secrets Management

✅ **DO**:
- Store secrets in `.env` (NOT in git)
- Use GitHub Secrets for CI/CD
- Rotate tokens regularly
- Use strong passwords

❌ **DON'T**:
- Commit `.env` to version control
- Hardcode passwords in code
- Share tokens publicly
- Use default credentials

### Network Security

- Services communicate via internal Docker network
- Frontend proxy to backend via Nginx
- Health checks for all services
- Alpine images for minimal attack surface

### Scanning

- Trivy scans base images for vulnerabilities
- npm audit checks dependencies
- ESLint for code quality

---

## 📊 Monitoring & Logs

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db

# Last 100 lines
docker-compose logs --tail=100
```

### Health Checks

```bash
# Backend health
curl http://localhost:5000/actuator/health

# Frontend
curl http://localhost/

# Database
docker-compose exec db pg_isready -U ecomuser
```

---

## 🧪 Testing Strategy

### Backend Tests
- Unit tests (services, repositories)
- Integration tests (with database)
- Security tests

```bash
mvn test
mvn verify  # includes integration tests
```

### Frontend Tests
- Component tests
- Integration tests
- E2E tests (optional)

```bash
npm test -- --watchAll=false
```

### CI/CD Testing
- Automatic test execution on every push
- Fail-fast approach
- Database service for integration tests

---

## 🤝 Contributing

### Branching Strategy

```bash
# Feature branch
git checkout -b feature/feature-name

# Make changes and commit
git commit -m "feat: add feature"

# Push and create pull request
git push origin feature/feature-name
```

### Pull Request Process

1. Create feature branch
2. Make changes and write tests
3. Ensure CI/CD passes
4. Submit pull request
5. Code review approval
6. Merge to main

---

## 📝 License

This project is part of a university DevOps lab assignment.

---

## 📞 Support

For issues and questions:

1. Check GitHub Issues
2. Review logs with `docker-compose logs`
3. Test locally first
4. Submit issue with logs and steps to reproduce

---

## 🎯 Lab Assignment

This project fulfills the DevOps lab requirements:

✅ Multi-stage Dockerfiles for backend and frontend
✅ Docker Compose with services (backend, frontend, database)
✅ CI/CD pipeline with 5 stages
✅ Security scanning and linting
✅ Testing with database service
✅ Docker Hub deployment
✅ GitHub Actions automation
✅ Proper secrets management
✅ Comprehensive documentation

---

## 🌐 Live Deployment (Render.com)

**✅ APPLICATION IS LIVE ON RENDER!**

| Service | Status | URL |
|---------|--------|-----|
| 🎨 Frontend | 🟢 Live | [ecommerce-frontend.onrender.com](https://ecommerce-frontend.onrender.com) |
| 🚀 Backend API | 🟢 Live | [ecommerce-backend.onrender.com](https://ecommerce-backend.onrender.com) |
| 💚 Health Check | 🟢 Live | [API Health Status](https://ecommerce-backend.onrender.com/actuator/health) |
| 🗄️ Database | 🟢 Live | PostgreSQL (Private) |

**⚠️ Note**: Free tier services sleep after 15 minutes of inactivity. First request may take 30-60 seconds to wake up.

**Deployment Guides**:
- � [`RENDER_DEPLOYMENT.md`](RENDER_DEPLOYMENT.md) - Complete deployment guide
- ⚡ [`RENDER_QUICK_START.md`](RENDER_QUICK_START.md) - 10-minute quick deployment

**Deployment Features**:
- ✅ Automatic HTTPS/SSL certificates
- ✅ CDN-backed frontend hosting
- ✅ Managed PostgreSQL database
- ✅ Auto-deploy on Git push (master branch)
- ✅ Health monitoring and logs
- ✅ Zero-downtime deployments

---

## �📚 Complete Documentation

This project includes comprehensive guides for quick submission:

| Document | Purpose | Time to Read |
|----------|---------|--------------|
| [`IMPLEMENTATION_COMPLETE.md`](IMPLEMENTATION_COMPLETE.md) | ✅ What's been implemented | 5 min |
| [`EXPRESS_GUIDE.md`](EXPRESS_GUIDE.md) | ⚡ 30-minute submission guide | 3 min |
| [`QUICK_START.md`](QUICK_START.md) | 🚀 Complete setup guide | 10 min |
| [`SCREENSHOTS_GUIDE.md`](SCREENSHOTS_GUIDE.md) | 📸 Screenshot instructions | 5 min |
| [`SUBMISSION_CHECKLIST.md`](SUBMISSION_CHECKLIST.md) | ✓ Pre-submission checklist | 10 min |
| [`RENDER_QUICK_START.md`](RENDER_QUICK_START.md) | 🌐 Render deployment (10 min) | 5 min |
| [`RENDER_DEPLOYMENT.md`](RENDER_DEPLOYMENT.md) | 🌐 Complete Render guide | 15 min |
| [`devops_report.md`](devops_report.md) | 📄 Complete DevOps report | 15 min |
| `verify-submission.ps1` | 🔍 Automated verification script | Run it! |

---

**Last Updated**: October 30, 2025

---

## 🎓 Academic Compliance

This project is submitted as part of the **DevOps Lab Midterm Exam** at COMSATS University Islamabad, Lahore Campus.

**Verification:**
- ✅ All CI/CD logs are timestamped within the exam period
- ✅ Docker images are time-stamped and publicly available
- ✅ No hardcoded passwords (all use environment variables)
- ✅ Both team members have visible commits in repository
- ✅ Complete documentation and DevOps report included
