# Deploying SmartResume to Render

## Prerequisites
- GitHub account with Smart_Resume repository
- Render account (https://dashboard.render.com)

## Deployment Steps

### Option 1: Blueprint (Automated - Recommended)

1. **Go to Render Dashboard**
   - Visit: https://dashboard.render.com

2. **Create New Blueprint**
   - Click "New +" button
   - Select "Blueprint"

3. **Connect Repository**
   - Connect your GitHub account if not already connected
   - Select repository: `bholsinger09/Smart_Resume`
   - Branch: `main`

4. **Review Configuration**
   - Render will detect the `render.yaml` file
   - Review the 3 services:
     - PostgreSQL Database (smartresume-postgres)
     - Python Service (smartresume-python)
     - Rails App (smartresume-rails)

5. **Deploy**
   - Click "Apply"
   - Wait for all services to deploy (5-10 minutes)

6. **Get Your URL**
   - Once deployed, click on "smartresume-rails"
   - Copy the URL (e.g., https://smartresume-rails.onrender.com)

### Option 2: Manual Setup

If Blueprint doesn't work, create services manually:

#### 1. Create PostgreSQL Database
```
Name: smartresume-postgres
Database: smartresume_production
User: postgres
Region: Choose closest to you
```

#### 2. Create Python Service
```
Name: smartresume-python
Environment: Docker
Build Command: (automatic from Dockerfile)
Region: Same as database
Health Check Path: /health
Port: 8000
```

Environment Variables:
- `PORT` = `8000`

#### 3. Create Rails App
```
Name: smartresume-rails
Environment: Docker
Build Command: (automatic from Dockerfile)
Region: Same as database
Health Check Path: /
```

Environment Variables:
- `RAILS_ENV` = `production`
- `RAILS_SERVE_STATIC_FILES` = `true`
- `RAILS_LOG_TO_STDOUT` = `true`
- `SECRET_KEY_BASE` = (click "Generate" for random value)
- `DATABASE_URL` = (copy from PostgreSQL service)
- `PYTHON_SERVICE_URL` = `http://smartresume-python:8000`

## Post-Deployment

### 1. Run Database Migrations
In the Rails service shell:
```bash
bundle exec rails db:migrate RAILS_ENV=production
```

### 2. Test the Application
- Visit your Rails app URL
- Try uploading a resume
- Check that skill extraction works

### 3. Update PWA Manifest
Update `rails_app/public/manifest.json`:
```json
{
  "start_url": "https://your-app-url.onrender.com/"
}
```

### 4. Test iOS Installation
1. Open Safari on iPhone
2. Navigate to your Render URL
3. Tap Share → Add to Home Screen
4. Test the installed app

## Monitoring

### Check Logs
- Go to each service in Render dashboard
- Click "Logs" tab
- Monitor for errors

### Check Health
- PostgreSQL: Should show "Available"
- Python Service: Visit `/health` endpoint
- Rails App: Visit homepage

## Troubleshooting

### Services Won't Start
- Check logs for each service
- Verify environment variables are set
- Ensure DATABASE_URL is correctly linked

### Database Connection Errors
- Verify DATABASE_URL format
- Check PostgreSQL service is running
- Ensure Rails can connect to internal network

### Python Service Not Reachable
- Verify PYTHON_SERVICE_URL uses internal service name
- Check Python service logs
- Test `/health` endpoint

### Static Assets Not Loading
- Ensure `RAILS_SERVE_STATIC_FILES=true`
- Run `rails assets:precompile` if needed
- Check CORS settings

## Free Tier Limitations

- Services sleep after 15 minutes of inactivity
- First request after sleep takes 30-60 seconds
- 750 hours/month free (per service)
- Database: 1GB storage, 97 connection hours/month

## Upgrading

To stay active 24/7:
- Upgrade to Render's paid tier ($7/month per service)
- Or use a cron job to ping your app every 10 minutes

## Support

If deployment fails:
1. Check Render status page
2. Review service logs
3. Verify Dockerfile builds locally
4. Contact Render support

## Next Steps

After successful deployment:
- [ ] Set up custom domain (optional)
- [ ] Configure SSL certificate (automatic on Render)
- [ ] Set up monitoring/alerting
- [ ] Configure backups for database
- [ ] Test all features in production
- [ ] Share your app URL!
