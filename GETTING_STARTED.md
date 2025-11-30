# 🎯 SmartResume - Quick Start Guide

Welcome to SmartResume! This guide will help you get the application running in minutes.

## What is SmartResume?

SmartResume is an AI-powered Progressive Web App that:
- 📄 Extracts skills from resumes using spaCy NLP
- 🎯 Matches resumes against job descriptions
- 📊 Provides detailed scoring and recommendations
- 💾 Works offline with PWA capabilities
- ✅ Is fully test-driven

## Quick Start (Docker - Recommended)

### 1. Make scripts executable
```bash
chmod +x setup.sh run_tests.sh deploy.sh
```

### 2. Run setup
```bash
./setup.sh
```

This will:
- Build Docker containers
- Start PostgreSQL, Python service, and Rails
- Create and seed the database
- Make the app available at http://localhost:3000

### 3. Access the application
- **Web App**: http://localhost:3000
- **Python API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

## Manual Setup (Without Docker)

### Prerequisites
- Ruby 3.2.2
- Python 3.9+
- PostgreSQL 15
- Node.js 18+ (optional, for asset compilation)

### Step 1: Start Python Service

```bash
cd python_service

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Download spaCy model
python -m spacy download en_core_web_sm

# Start service
uvicorn app:app --reload --port 8000
```

Keep this terminal open. The Python service will run on http://localhost:8000

### Step 2: Start Rails App (New Terminal)

```bash
cd rails_app

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start Rails
rails server -p 3000
```

The Rails app will run on http://localhost:3000

## Using the Application

### 1. Browse Jobs
- Visit http://localhost:3000
- Click "Browse Jobs" to see available positions
- View job details and required skills

### 2. Upload Resume
- Click "Upload Resume" or navigate to "Resumes"
- Upload a PDF, DOCX, or TXT file
- Wait for AI skill extraction (a few seconds)

### 3. Match Resume with Job
- On a resume page, select a job from the dropdown
- Click "Create Match"
- View your match score and recommendations!

### 4. View Match Details
- See matched skills (what you have ✓)
- See missing skills (what to learn ⚠)
- Read personalized recommendations
- Match levels: Excellent (90%+), Good (70-89%), Fair (50-69%), Poor (<50%)

## Running Tests

### All Tests
```bash
./run_tests.sh
```

### Python Tests Only
```bash
cd python_service
pytest -v
```

### Rails Tests Only
```bash
cd rails_app
bundle exec rspec
```

## Architecture Overview

```
┌─────────────────────────────────────┐
│      Rails 7 Frontend (PWA)         │
│  - Job Management                   │
│  - Resume Storage                   │
│  - Match Calculation                │
│  - UI with Tailwind CSS             │
└───────────────┬─────────────────────┘
                │
                │ HTTP POST
                │ /extract-skills
                │
┌───────────────▼─────────────────────┐
│   Python FastAPI Microservice       │
│  - spaCy NLP Engine                 │
│  - Resume Text Extraction           │
│  - Skill Identification             │
└─────────────────────────────────────┘
```

## Project Structure

```
SmartResume/
├── python_service/          # Python FastAPI microservice
│   ├── app.py              # Main FastAPI application
│   ├── test_app.py         # Pytest test suite
│   ├── requirements.txt    # Python dependencies
│   └── Dockerfile          # Python container
│
├── rails_app/              # Rails 7 application
│   ├── app/
│   │   ├── controllers/    # Request handlers
│   │   ├── models/         # Database models
│   │   ├── services/       # Business logic
│   │   └── views/          # HTML templates
│   ├── db/
│   │   ├── migrate/        # Database migrations
│   │   └── seeds.rb        # Sample data
│   ├── spec/               # RSpec test suite
│   └── Dockerfile          # Rails container
│
├── docker-compose.yml      # Multi-container setup
├── setup.sh               # Automated setup script
├── run_tests.sh           # Test runner
└── README.md              # This file
```

## Key Features

### 🤖 AI Skill Extraction
- Uses spaCy NLP for intelligent skill detection
- Supports PDF, DOCX, and TXT formats
- Extracts technical skills, frameworks, tools
- Identifies organizations and entities

### 🎯 Smart Job Matching
- Compares resume skills vs job requirements
- Calculates match scores (0-100%)
- Identifies matched and missing skills
- Generates personalized recommendations

### 💾 PWA Capabilities
- Service worker for offline access
- Installable on desktop and mobile
- Cached resources for fast loading
- Works without internet connection

### ✅ Test-Driven Development
- Comprehensive pytest suite for Python
- RSpec tests for Rails models and services
- Factory Bot for test data
- WebMock/VCR for API mocking

## Troubleshooting

### Python service not starting?
```bash
# Ensure spaCy model is installed
python -m spacy download en_core_web_sm

# Check logs
docker-compose logs python_service
```

### Rails can't connect to database?
```bash
# Recreate database
rails db:drop db:create db:migrate db:seed
```

### Skills not being extracted?
- Verify Python service is running on port 8000
- Check `PYTHON_SERVICE_URL` environment variable
- Ensure resume file is valid (PDF, DOCX, or TXT)

## Deployment

### Deploy to GitHub
```bash
./deploy.sh
```

### Environment Variables
Create a `.env` file:
```bash
DATABASE_URL=postgresql://user:pass@host:5432/smart_resume_production
PYTHON_SERVICE_URL=http://python-service:8000
SECRET_KEY_BASE=your_secret_key_here
RAILS_ENV=production
```

## Next Steps

1. ✅ Upload your first resume
2. ✅ Create a job posting
3. ✅ Generate a match and see your score
4. ✅ Review recommendations
5. ✅ Run the test suite

## Support & Documentation

- **Full Documentation**: See [DEVELOPMENT.md](DEVELOPMENT.md)
- **GitHub Issues**: https://github.com/bholsinger09/Smart_Resume/issues
- **API Docs**: http://localhost:8000/docs (when Python service is running)

## Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Write tests for your changes
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file

---

Built with ❤️ using Ruby on Rails, Python, spaCy, and PostgreSQL
