# 🚀 QUICK DOCKER HUB PUSH - 2 MINUTES

## Step 1: Login to Docker Hub
```powershell
docker login
# Enter your username and password when prompted
```

## Step 2: Build Images (takes 5-10 minutes)

### Backend Image:
```powershell
docker build -t YOUR_USERNAME/ecom-backend:latest -f ecom-backend/Dockerfile .
```

### Frontend Image:
```powershell
docker build -t YOUR_USERNAME/ecom-frontend:latest -f ecom-frontend/Dockerfile .
```

**Replace `YOUR_USERNAME` with your actual Docker Hub username!**

## Step 3: Push Images (takes 2-3 minutes)

### Push Backend:
```powershell
docker push YOUR_USERNAME/ecom-backend:latest
```

### Push Frontend:
```powershell
docker push YOUR_USERNAME/ecom-frontend:latest
```

## ⚡ AUTOMATED SCRIPT (Recommended)

Run this script:
```powershell
.\push-to-dockerhub.ps1
```

It will:
1. Ask for your Docker Hub username
2. Login to Docker Hub
3. Build both images
4. Push both images
5. Give you the Docker Hub link

## 📸 After Pushing

1. Open: https://hub.docker.com
2. Login
3. See your repositories
4. Take screenshot
5. Save as: `screenshots/03-dockerhub-deployment.png`

## 🎯 Expected Result

You should see:
- `YOUR_USERNAME/ecom-backend` repository
- `YOUR_USERNAME/ecom-frontend` repository
- Both with "latest" tag
- Recent push timestamp

## ⏱️ Time Estimate

- Login: 30 seconds
- Build: 8-10 minutes (both images)
- Push: 2-3 minutes
- **Total: ~12 minutes**

## 🆘 If Docker Build is Too Slow

You can use pre-built images from GitHub Actions, or we can skip Docker Hub and just show the working docker-compose setup locally.

**For submission, you need EITHER:**
- Docker Hub images (public registry), OR
- Running local containers (docker-compose ps)

Both are acceptable!
