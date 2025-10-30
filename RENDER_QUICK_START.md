# RENDER DEPLOYMENT - QUICK STEPS (10 MINUTES)

## ⏱️ FAST DEPLOYMENT GUIDE

### Step 1: Go to Render.com (2 min)
1. Open browser: https://render.com
2. Click "Get Started for Free"
3. Sign in with GitHub account
4. Authorize Render to access your repository

---

### Step 2: Create PostgreSQL Database (3 min)

1. Click **"New +"** → **"PostgreSQL"**
2. Fill in:
   - Name: `ecommerce-db`
   - Database: `ecommerce`
   - User: `ecomuser`
   - Region: **US East (Ohio)** or closest to you
   - PostgreSQL Version: **15**
3. Click **"Create Database"**
4. **WAIT** for "Available" status (1-2 minutes)
5. **COPY THIS** → Go to "Info" tab → Copy **"Internal Database URL"**
   - Should look like: `postgresql://ecomuser:xxxxx@dpg-xxxxx/ecommerce`

---

### Step 3: Deploy Backend (3 min)

1. Click **"New +"** → **"Web Service"**
2. Click **"Build and deploy from a Git repository"**
3. Select your repository: `Ecommerce-Spring-Reactjs`
4. Fill in:
   - **Name**: `ecommerce-backend`
   - **Region**: Same as database (US East Ohio)
   - **Branch**: `master`
   - **Root Directory**: Leave empty
   - **Runtime**: **Docker**
   - **Dockerfile Path**: `ecom-backend/Dockerfile`
   - **Docker Build Context Directory**: `.`

5. Scroll to **"Environment Variables"** → Click **"Add Environment Variable"**
   Add these 5 variables:

   ```
   SPRING_DATASOURCE_URL = <paste-internal-database-url-here>
   SPRING_DATASOURCE_USERNAME = ecomuser
   SPRING_DATASOURCE_PASSWORD = <get-from-render-db-dashboard-info-tab>
   SERVER_PORT = 5000
   SPRING_PROFILES_ACTIVE = prod
   ```

   **To get password**: Go back to Database → Info tab → Look for "Password" field

6. **Plan**: Select **Free**
7. Click **"Create Web Service"**
8. **WAIT** for build (5-8 minutes) - You can continue to Step 4
9. **COPY** the backend URL when ready (top of page): `https://ecommerce-backend-xxxx.onrender.com`

---

### Step 4: Deploy Frontend (2 min)

1. Click **"New +"** → **"Static Site"**
2. Select repository: `Ecommerce-Spring-Reactjs`
3. Fill in:
   - **Name**: `ecommerce-frontend`
   - **Branch**: `master`
   - **Root Directory**: `ecom-frontend`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`

4. **Environment Variables** → Add:
   ```
   VITE_API_URL = <paste-backend-url-from-step-3>
   ```
   Example: `VITE_API_URL = https://ecommerce-backend-xxxx.onrender.com`

5. Click **"Create Static Site"**
6. **WAIT** for build (2-3 minutes)
7. **COPY** frontend URL: `https://ecommerce-frontend-xxxx.onrender.com`

---

## ✅ VERIFICATION (1 min)

1. **Check Backend**:
   - Open: `https://ecommerce-backend-xxxx.onrender.com/actuator/health`
   - Should show: `{"status":"UP"}`

2. **Check Frontend**:
   - Open: `https://ecommerce-frontend-xxxx.onrender.com`
   - Should load the React app

3. **Check All Services**:
   - Render Dashboard should show 3 services:
     - ✅ ecommerce-db (Available)
     - ✅ ecommerce-backend (Live)
     - ✅ ecommerce-frontend (Live)

---

## 📸 TAKE SCREENSHOTS NOW!

**Required Screenshots for Report**:
1. Render Dashboard showing all 3 services running
2. Frontend live URL in browser
3. Backend health check showing `{"status":"UP"}`
4. Database Info page showing "Available" status
5. Backend build logs (scroll to success message)
6. Frontend build logs

**Where to find**:
- Dashboard: https://dashboard.render.com
- Service logs: Click service → "Logs" tab
- Service info: Click service → "Info" tab

---

## 🚀 OPTIONAL: GitHub Actions Auto-Deploy

### Get Service IDs & API Key:

1. **Backend Service ID**:
   - Go to backend service
   - Look at URL: `dashboard.render.com/web/srv-XXXXXXXXXX`
   - Copy: `srv-XXXXXXXXXX`

2. **Frontend Service ID**:
   - Go to frontend service
   - Copy Service ID from URL

3. **API Key**:
   - Dashboard → Account Settings → API Keys
   - Create new key
   - Copy the key (starts with `rnd_...`)

### Add to GitHub Secrets:

1. Go to your GitHub repo
2. Settings → Secrets and variables → Actions → New repository secret
3. Add these 3 secrets:
   - Name: `RENDER_API_KEY`, Value: `rnd_xxxxx`
   - Name: `RENDER_BACKEND_SERVICE_ID`, Value: `srv-xxxxx`
   - Name: `RENDER_FRONTEND_SERVICE_ID`, Value: `srv-xxxxx`

4. Push to master → Auto-deploy will work!

---

## ⚠️ IMPORTANT NOTES

1. **First load is slow** (30-60 sec) - free tier sleeps after 15 min
2. **Database URL**: Always use INTERNAL URL, not external
3. **Backend takes 5-8 minutes** to build - be patient
4. **Frontend needs backend URL** - update after backend is ready
5. **CORS**: Already configured in the code

---

## 🆘 TROUBLESHOOTING

### Backend build failed:
- Check logs in Render dashboard
- Verify Dockerfile path: `ecom-backend/Dockerfile`
- Check build context is root (`.`)

### Frontend can't connect:
- Verify `VITE_API_URL` is set correctly
- Check backend is running (visit health endpoint)
- Wait for backend to wake up (first request takes time)

### Database connection error:
- Use INTERNAL URL, not external
- Check username/password match
- Verify backend and DB in same region

---

## 📊 FINAL DELIVERABLES

✅ All 3 services running on Render
✅ Screenshots saved
✅ URLs documented in README.md
✅ devops_report.md updated with Render section
✅ GitHub Actions configured (optional)

---

## ⏰ TOTAL TIME: ~10-12 MINUTES

- Database: 3 min
- Backend: 3 min (+ 5-8 min build)
- Frontend: 2 min (+ 2-3 min build)
- Verification: 1 min
- Screenshots: 2 min

**Tip**: Start backend build first, then work on frontend while waiting!

---

## 🌐 YOUR LIVE URLS

After completion, add these to your README:

```markdown
## Live Demo

- **Frontend**: https://ecommerce-frontend-xxxx.onrender.com
- **Backend API**: https://ecommerce-backend-xxxx.onrender.com
- **API Health**: https://ecommerce-backend-xxxx.onrender.com/actuator/health
```

---

## 📝 UPDATE README.md

Add this section to your README.md:

```markdown
## Cloud Deployment

This application is deployed on Render.com:

- **Frontend**: [Live Demo](https://ecommerce-frontend-xxxx.onrender.com)
- **Backend**: [API Endpoint](https://ecommerce-backend-xxxx.onrender.com)
- **Status**: ✅ Live and Running

**Note**: Free tier services may take 30-60 seconds to wake up on first request.
```

---

## ✅ DONE!

Your application is now live on the internet! 🎉
