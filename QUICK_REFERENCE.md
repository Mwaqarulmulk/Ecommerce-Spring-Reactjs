# 📋 Quick Reference Commands

## Docker Compose Commands

### Start Services
```bash
# Build and start all services
docker-compose up --build

# Start in background
docker-compose up -d --build

# Start without rebuild
docker-compose up
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop and remove volumes (database data deleted)
docker-compose down -v

# Stop specific service
docker-compose stop backend
```

### View Status
```bash
# List all containers
docker-compose ps

# View logs (all services)
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# Logs for specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### Service Management
```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart backend

# View container IP addresses
docker-compose exec backend hostname -I

# Access container shell
docker-compose exec backend sh
docker-compose exec db sh
```

---

## Backend Commands

### Maven Build
```bash
# Clean build
mvn clean install

# Build without tests
mvn clean install -DskipTests

# Run application
mvn spring-boot:run

# Run tests
mvn test

# Run specific test
mvn test -Dtest=UserServiceTest

# Compile only
mvn compile
```

### Database Migrations
```bash
# View database
docker-compose exec db psql -U ecomuser -d ecommerce

# Common SQL
SELECT * FROM users;
SELECT COUNT(*) FROM orders;
\dt  # List tables
```

---

## Frontend Commands

### npm Development
```bash
# Install dependencies
npm install

# Development server with HMR
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Linting
npm run lint

# Run tests
npm test

# Clean dependencies
rm -rf node_modules
npm install
```

---

## Docker Commands

### Image Management
```bash
# Build image
docker build -t image-name:tag .

# Push to Docker Hub
docker push your-username/image-name:tag

# Pull image
docker pull your-username/image-name:tag

# List images
docker images

# Remove image
docker rmi image-name:tag
```

### Container Management
```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Start container
docker start container-id

# Stop container
docker stop container-id

# Remove container
docker rm container-id

# View logs
docker logs -f container-id
```

---

## Git Commands

### Repository Management
```bash
# Clone repository
git clone https://github.com/username/repo.git

# Check status
git status

# Add changes
git add .

# Commit changes
git commit -m "message"

# Push to remote
git push origin main

# Pull latest changes
git pull origin main
```

### Branching
```bash
# List branches
git branch

# Create new branch
git branch feature/feature-name

# Switch branch
git checkout feature/feature-name

# Or switch and create
git checkout -b feature/feature-name

# Delete branch
git branch -d feature/feature-name

# Merge branch
git merge feature/feature-name
```

---

## Verification Commands

### Service Health Checks
```bash
# Backend health
curl http://localhost:5000/actuator/health

# Frontend status
curl http://localhost/

# Database connection
docker-compose exec db pg_isready -U ecomuser
```

### Port Testing
```bash
# Check if port is listening
lsof -i :5000   # Backend
lsof -i :5173   # Frontend
lsof -i :80     # Frontend (Docker)
lsof -i :5432   # Database
```

### Network Testing
```bash
# Test backend from frontend container
docker-compose exec frontend curl http://backend:5000/

# Test database from backend
docker-compose exec backend nslookup db
```

---

## Debugging Commands

### View Configuration
```bash
# Environment variables
docker-compose exec backend env | grep SPRING

# Database settings
docker-compose exec db psql -U ecomuser -c "SHOW ALL;"
```

### Performance Monitoring
```bash
# Container resource usage
docker stats

# Continuous monitoring
docker stats --no-stream=false
```

### Log Inspection
```bash
# Last 100 lines
docker-compose logs --tail=100

# Timestamp format
docker-compose logs --timestamps

# Previous container logs
docker-compose logs --since 10m
```

---

## CI/CD Commands

### GitHub Actions
```bash
# List workflow runs (requires gh CLI)
gh run list

# View run details
gh run view <run-id>

# Download logs
gh run logs <run-id>

# Cancel run
gh run cancel <run-id>
```

---

## Common Scenarios

### Scenario 1: Fresh Start
```bash
docker-compose down -v
rm -rf ecom-frontend/node_modules
docker-compose up --build
```

### Scenario 2: Database Issues
```bash
docker-compose stop db
docker-compose rm db
docker volume rm $(docker volume ls -f "name=db_data" -q)
docker-compose up db
```

### Scenario 3: Rebuild Single Service
```bash
docker-compose down backend
docker-compose build backend
docker-compose up backend
```

### Scenario 4: Test Pipeline Locally
```bash
# Simulate GitHub Actions
./mvn clean test
cd ecom-frontend && npm run build
cd ..
docker-compose up --build
```

---

## Performance Optimization

### Faster Builds
```bash
# Maven parallel build
mvn -T 4 clean install

# npm ci (faster than npm install)
npm ci

# Docker build with cache
docker build --cache-from image-name:latest .
```

### Reduce Image Size
```bash
# Check image layers
docker history image-name

# Build with BuildKit (better caching)
DOCKER_BUILDKIT=1 docker build .

# Multi-stage optimization
# Keep build dependencies out of runtime image
```

---

## Emergency Commands

### Clean Everything
```bash
# Remove all containers
docker-compose down -v --remove-orphans

# Remove all unused images
docker image prune -a

# Remove all unused volumes
docker volume prune -f
```

### Kill Port Usage
```bash
# Find process using port
lsof -i :5000

# Kill process
kill -9 <PID>

# Linux: use fuser
fuser -k 5000/tcp
```

### Reset to Clean State
```bash
docker-compose down -v
rm -rf ecom-backend/target
rm -rf ecom-frontend/node_modules ecom-frontend/dist
git clean -fd
docker-compose up --build
```

---

## Useful Aliases

Add to your shell profile (~/.bashrc or ~/.zshrc):

```bash
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dcl="docker-compose logs -f"
alias dcps="docker-compose ps"
alias mvnb="mvn clean install -DskipTests"
alias npmb="npm run build"
```

Then use:
```bash
dc up -d --build
dcl backend
dcps
```

---

Generated: October 30, 2025
