#!/bin/bash

# Configuration
REPO_URL="https://github.com/bholsinger09/Smart_Resume.git"
BRANCH="main"

echo "📦 Deploying SmartResume to GitHub..."

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git remote add origin $REPO_URL
fi

# Add all files
echo "Adding files..."
git add .

# Commit changes
echo "Creating commit..."
git commit -m "feat: Complete PWA application with Python skill extraction and Rails job matching

- Python FastAPI service with spaCy for skill extraction
- Rails 7 application with job management and matching
- PWA capabilities with service worker and manifest
- Comprehensive test suite (RSpec and pytest)
- Docker Compose setup for easy deployment
- Job matching algorithm with scoring and recommendations
- Resume upload with file parsing (PDF, DOCX, TXT)
- Responsive UI with Tailwind CSS"

# Push to GitHub
echo "Pushing to GitHub..."
git branch -M $BRANCH
git push -u origin $BRANCH --force

echo "✅ Deployment complete!"
echo "🌐 Repository: $REPO_URL"
