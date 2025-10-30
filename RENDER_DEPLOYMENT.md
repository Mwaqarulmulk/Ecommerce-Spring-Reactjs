# Render Deployment Guide

## Quick Deployment Steps

### Step 1: Create Render Account
1. Go to https://render.com
2. Sign up with GitHub account
3. Verify email

### Step 2: Deploy PostgreSQL Database

1. From Render Dashboard, click **New +** → **PostgreSQL**
2. Configure:
   - **Name**: `ecommerce-db`
   - **Database**: `ecommerce`
   - **User**: `ecomuser`
   - **Region**: Select closest to you
   - **Plan**: Free
3. Click **Create Database**
4. **IMPORTANT**: Copy the **Internal Database URL** (starts with `postgresql://`)

### Step 3: Deploy Spring Boot Backend

#### Option A: Using Web Interface (RECOMMENDED)

1. Click **New +** → **Web Service**
2. Connect your GitHub repository: `Ecommerce-Spring-Reactjs`
3. Configure:
   - **Name**: `ecommerce-backend`
   - **Root Directory**: Leave empty
   - **Environment**: `Docker`
   - **Region**: Same as database
   - **Branch**: `master`
   - **Dockerfile Path**: `ecom-backend/Dockerfile`
   - **Plan**: Free

4. **Environment Variables** - Add these:
   ```
   SPRING_DATASOURCE_URL=<paste-internal-database-url-from-step-2>
   SPRING_DATASOURCE_USERNAME=ecomuser
   SPRING_DATASOURCE_PASSWORD=<get-from-render-db-dashboard>
   SPRING_JPA_HIBERNATE_DDL_AUTO=update
   SERVER_PORT=5000
   SPRING_PROFILES_ACTIVE=prod
   ```

5. Click **Create Web Service**
6. Wait 5-10 minutes for build and deployment
7. Copy the backend URL (e.g., `https://ecommerce-backend-xyz.onrender.com`)

#### Option B: Using Build Command (Alternative)

If Docker doesn't work, use:
- **Environment**: `Java`
- **Build Command**: 
  ```bash
  cd ecom-backend && chmod +x mvnw && ./mvnw clean package -DskipTests
  ```
- **Start Command**:
  ```bash
  cd ecom-backend && java -jar target/*.jar
  ```

### Step 4: Deploy React Frontend

1. Click **New +** → **Static Site**
2. Connect same GitHub repository
3. Configure:
   - **Name**: `ecommerce-frontend`
   - **Root Directory**: `ecom-frontend`
   - **Branch**: `master`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`
   - **Plan**: Free

4. **Environment Variables**:
   ```
   VITE_API_URL=<paste-backend-url-from-step-3>
   ```
   Example: `VITE_API_URL=https://ecommerce-backend-xyz.onrender.com`

5. Click **Create Static Site**
6. Wait 3-5 minutes for deployment
7. Copy frontend URL (e.g., `https://ecommerce-frontend-xyz.onrender.com`)

### Step 5: Update Frontend API Configuration

You may need to update the frontend to use the backend URL:

1. Check `ecom-frontend/src/api/api.js`
2. Update base URL to use environment variable:
   ```javascript
   const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';
   ```

### Step 6: Configure CORS in Backend

Update `ecom-backend/src/main/java/com/jianquanwang/ecommerce/config/AppConfig.java`:

```java
@Bean
public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**")
                    .allowedOrigins(
                        "http://localhost:3000",
                        "https://ecommerce-frontend-xyz.onrender.com" // Add your frontend URL
                    )
                    .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                    .allowedHeaders("*")
                    .allowCredentials(true);
        }
    };
}
```

### Step 7: Setup GitHub Actions Auto-Deploy (Optional)

1. Get Render API Key:
   - Go to Render Dashboard → Account Settings → API Keys
   - Create new API key
   - Copy the key

2. Get Service IDs:
   - Backend: Go to backend service → Settings → copy Service ID
   - Frontend: Go to frontend service → Settings → copy Service ID

3. Add GitHub Secrets:
   - Go to your GitHub repo → Settings → Secrets and variables → Actions
   - Add these secrets:
     - `RENDER_API_KEY`: Your API key
     - `RENDER_BACKEND_SERVICE_ID`: Backend service ID
     - `RENDER_FRONTEND_SERVICE_ID`: Frontend service ID

4. Push to master branch - deployment will auto-trigger!

---

## Troubleshooting

### Backend Won't Start
- Check logs in Render dashboard
- Verify database URL is correct (use INTERNAL URL, not external)
- Ensure all environment variables are set
- Check that `SERVER_PORT=5000` (Render uses port 5000 for free tier)

### Frontend Shows "Connection Refused"
- Verify `VITE_API_URL` is set correctly
- Check backend is running (visit backend URL + `/actuator/health`)
- Update CORS configuration in backend

### Database Connection Failed
- Use **Internal Database URL** from Render PostgreSQL dashboard
- Verify username and password match
- Check database is in same region as backend

### Build Failed
- Check build logs for errors
- Verify Dockerfile paths are correct
- Try manual build commands option instead of Docker

---

## Live URLs

After deployment, you'll have:
- **Frontend**: `https://ecommerce-frontend-xyz.onrender.com`
- **Backend API**: `https://ecommerce-backend-xyz.onrender.com`
- **Database**: Internal only (not publicly accessible)

---

## Important Notes

⚠️ **Free Tier Limitations**:
- Services sleep after 15 minutes of inactivity
- First request after sleep takes 30-60 seconds to wake up
- 750 hours/month free (shared across services)
- Limited resources (512 MB RAM)

💡 **Performance Tips**:
- Keep at least one service active to prevent all sleeping
- Use paid tier for production use
- Add health check endpoint to keep services warm

---

## Cost Estimate

- PostgreSQL: **$0** (Free tier)
- Backend Web Service: **$0** (Free tier)
- Frontend Static Site: **$0** (Free tier)

**Total Monthly Cost: $0**

---

## Next Steps

1. ✅ Deploy all three services
2. ✅ Test the application
3. ✅ Take screenshots of:
   - Running services in Render dashboard
   - Live frontend URL
   - API health check
   - Database connection
4. ✅ Add screenshots to `devops_report.md`
5. ✅ Update README with live URLs
6. ✅ Push final changes to trigger CI/CD

---

## Manual Deployment Commands (CLI)

If you prefer CLI:

```bash
# Install Render CLI
npm install -g render

# Login
render login

# Deploy services (from project root)
render services create --type postgres --name ecommerce-db
render services create --type web --name ecommerce-backend --dockerfile ecom-backend/Dockerfile
render services create --type static --name ecommerce-frontend --build-command "cd ecom-frontend && npm install && npm run build" --publish-dir ecom-frontend/dist
```

---

## Support

If deployment fails:
- Check Render logs: Dashboard → Service → Logs
- Review build output
- Verify all environment variables
- Check GitHub Actions logs
- Consult Render documentation: https://render.com/docs
