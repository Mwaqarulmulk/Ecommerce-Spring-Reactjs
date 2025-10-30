# 🚀 FAST RENDER DEPLOYMENT (5 MINUTES)

## Your API Key: `rnd_dDmVRQFB82oTLl56P8aa8ZG6yrpU`

---

## STEP 1: Go to Render Dashboard (1 min)

1. Open: **https://dashboard.render.com**
2. Sign in with GitHub
3. You should see empty dashboard

---

## STEP 2: Deploy PostgreSQL (2 min)

1. Click **"New +"** button (top right)
2. Select **"PostgreSQL"**
3. Fill in:
   - **Name**: `ecommerce-db`
   - **Database**: `ecommerce`
   - **User**: `ecomuser`
   - **PostgreSQL Version**: `15`
   - **Region**: **Oregon (US West)**
   - **Datadog API Key**: Leave empty
   
4. Click **"Create Database"** (bottom)

5. **WAIT 1-2 MINUTES** for status to show "Available"

6. Click on **"ecommerce-db"** → Go to **"Info"** tab

7. **COPY THESE** (you'll need them):
   ```
   Internal Database URL: postgresql://ecomuser:XXXX@dpg-XXXX/ecommerce
   Password: XXXXXXXXXXXX
   ```

---

## STEP 3: Deploy Backend (1 min setup + 8 min build)

1. Click **"New +"** → **"Web Service"**

2. Click **"Build and deploy from a Git repository"**

3. **Connect GitHub**: Click **"Connect account"** if not connected

4. Find and select: **`ghulam-mujtaba5/Ecommerce-Spring-Reactjs`**

5. Click **"Connect"**

6. Fill in the form:
   - **Name**: `ecommerce-backend`
   - **Region**: **Oregon (US West)** (same as database)
   - **Branch**: `master`
   - **Root Directory**: Leave empty
   - **Runtime**: Select **"Docker"**
   - **Dockerfile Path**: `ecom-backend/Dockerfile`

7. Scroll down to **"Advanced"** → Click to expand

8. **Environment Variables** - Click **"Add Environment Variable"** and add these 5:

   | Key | Value |
   |-----|-------|
   | `SPRING_DATASOURCE_URL` | Paste the Internal Database URL from Step 2 |
   | `SPRING_DATASOURCE_USERNAME` | `ecomuser` |
   | `SPRING_DATASOURCE_PASSWORD` | Paste password from Step 2 |
   | `SERVER_PORT` | `10000` |
   | `SPRING_PROFILES_ACTIVE` | `prod` |

9. **Instance Type**: Select **"Free"**

10. Click **"Create Web Service"** (bottom)

11. **BUILD STARTS AUTOMATICALLY** - This takes 5-8 minutes

12. **COPY THE URL** at top of page (like: `https://ecommerce-backend-xxxx.onrender.com`)

---

## STEP 4: Deploy Frontend (1 min setup + 3 min build)

1. Click **"New +"** → **"Static Site"**

2. Select repository: **`ghulam-mujtaba5/Ecommerce-Spring-Reactjs`**

3. Fill in:
   - **Name**: `ecommerce-frontend`
   - **Branch**: `master`
   - **Root Directory**: `ecom-frontend`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`

4. **Environment Variables** - Click **"Add Environment Variable"**:

   | Key | Value |
   |-----|-------|
   | `VITE_API_URL` | Paste backend URL from Step 3 |

   Example: `https://ecommerce-backend-xxxx.onrender.com`

5. Click **"Create Static Site"**

6. **BUILD STARTS** - Takes 2-3 minutes

7. **COPY FRONTEND URL** (like: `https://ecommerce-frontend-xxxx.onrender.com`)

---

## ✅ VERIFICATION (After builds complete)

### Check All Services:
Go to: **https://dashboard.render.com**

You should see 3 services:
- 🟢 **ecommerce-db** (Available)
- 🟢 **ecommerce-backend** (Live) - may show "Building" initially
- 🟢 **ecommerce-frontend** (Live) - may show "Building" initially

### Test Backend:
Open: `https://ecommerce-backend-xxxx.onrender.com/actuator/health`

Should show:
```json
{"status":"UP"}
```

### Test Frontend:
Open: `https://ecommerce-frontend-xxxx.onrender.com`

Should load the React application

---

## 📸 SCREENSHOTS TO TAKE

1. **Render Dashboard** showing all 3 services with green status
2. **Backend service page** showing "Live" status
3. **Frontend service page** showing "Live" status
4. **Database info page** showing connection details
5. **Browser with frontend URL** open and working
6. **Browser with backend health check** showing `{"status":"UP"}`

---

## 🔗 YOUR LIVE URLS

After deployment completes, you'll have:

```
Frontend (Public): https://ecommerce-frontend-xxxx.onrender.com
Backend API:       https://ecommerce-backend-xxxx.onrender.com
Health Check:      https://ecommerce-backend-xxxx.onrender.com/actuator/health
Database:          Internal only (not public)
```

---

## ⚠️ IMPORTANT NOTES

1. **First request takes 30-60 seconds** (free tier sleeps after inactivity)
2. **Backend build takes 5-8 minutes** - be patient!
3. **Frontend build takes 2-3 minutes**
4. **Both services must be "Live"** before testing
5. **Database must be "Available"** before backend works

---

## 🆘 IF SOMETHING FAILS

### Backend won't start:
- Click backend service → **"Logs"** tab
- Look for errors
- Check database URL is correct (must be INTERNAL URL)
- Verify all 5 environment variables are set

### Frontend shows error:
- Check backend is running first
- Verify `VITE_API_URL` is set correctly
- Look at **"Logs"** for build errors

### Need to rebuild:
- Go to service page
- Click **"Manual Deploy"** → **"Deploy latest commit"**

---

## ✅ FINAL CHECKLIST

- [ ] Database shows "Available"
- [ ] Backend shows "Live" (not "Building")
- [ ] Frontend shows "Live" (not "Building")
- [ ] Health check returns `{"status":"UP"}`
- [ ] Frontend loads in browser
- [ ] All screenshots taken
- [ ] URLs copied for documentation

---

## 🎯 TIME BREAKDOWN

- Database setup: 2 minutes
- Backend setup: 1 minute (+ 8 min build)
- Frontend setup: 1 minute (+ 3 min build)
- **Total active time: ~4 minutes**
- **Total wait time: ~11 minutes**

---

## 📝 UPDATE YOUR README.md

After deployment, add this to your README.md:

```markdown
## 🌐 Live Demo

**Application is deployed on Render.com:**

- 🎨 **Frontend**: https://ecommerce-frontend-xxxx.onrender.com
- 🚀 **Backend**: https://ecommerce-backend-xxxx.onrender.com
- 💚 **Health**: https://ecommerce-backend-xxxx.onrender.com/actuator/health

**Note**: First request may take 30-60 seconds (free tier warm-up)
```

---

## 🎉 YOU'RE DONE!

Your application is now live on the internet! Share the frontend URL with your professor.

**Dashboard**: https://dashboard.render.com
**Documentation**: Already in your repo (RENDER_DEPLOYMENT.md)
