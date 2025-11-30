# 🎯 SmartResume - AI-Powered Resume Matcher

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Ruby](https://img.shields.io/badge/ruby-3.2.2-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/rails-7.1-red.svg)](https://rubyonrails.org/)

A Progressive Web App (PWA) that helps job seekers match their resumes with job descriptions using AI-powered skill extraction.

## 🌟 Features

- 📄 **Resume Upload** - Support for PDF, DOCX, and TXT files
- 🤖 **AI Skill Extraction** - Powered by spaCy NLP engine
- 🎯 **Smart Job Matching** - Algorithm-based scoring (0-100%)
- 📊 **Detailed Recommendations** - Personalized career advice
- 💾 **PWA Capabilities** - Offline-first with service workers
- ✅ **Test-Driven** - Comprehensive RSpec and pytest suites
- 🐳 **Docker Ready** - One-command setup with Docker Compose

## 🏗️ Architecture

```
┌─────────────────┐
│   Rails 7 PWA   │ ← User Interface & Business Logic
│   + Tailwind    │
└────────┬────────┘
         │ HTTP API
         ▼
┌─────────────────┐
│ Python FastAPI  │ ← spaCy NLP Skill Extraction
│   + spaCy NLP   │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  PostgreSQL 15  │ ← Jobs, Resumes, Skills, Matches
└─────────────────┘
```

## 🚀 Quick Start

### Option 1: Docker (Recommended - 2 Minutes)

```bash
# Clone the repository
git clone https://github.com/bholsinger09/Smart_Resume.git
cd Smart_Resume

# Make scripts executable
chmod +x setup.sh run_tests.sh validate.sh

# Run automated setup
./setup.sh

# Visit http://localhost:3000 🎉
```

### Option 2: Manual Setup (5 Minutes)

**Prerequisites:** Ruby 3.2.2, Python 3.9+, PostgreSQL 15

#### Terminal 1: Python Service

```bash
cd python_service
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python -m spacy download en_core_web_sm
uvicorn app:app --reload --port 8000
```

#### Terminal 2: Rails Application

```bash
cd rails_app
bundle install
rails db:create db:migrate db:seed
rails server -p 3000
```

**Access Points:**
- Web App: http://localhost:3000
- Python API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## 🧪 Running Tests

```bash
# All tests (Python + Rails)
./run_tests.sh

# Python tests only
cd python_service && pytest -v

# Rails tests only
cd rails_app && bundle exec rspec

# Validate project structure
./validate.sh
```

## 📖 Documentation

- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Quick start guide and tutorials
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Developer documentation and API reference
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete project overview

## 🎯 How It Works

### 1. Upload Resume
```
User uploads PDF/DOCX/TXT → Rails saves file → Calls Python service
```

### 2. Extract Skills
```
Python service → spaCy NLP → Pattern matching → Returns skills JSON
```

### 3. Match with Job
```
Rails compares skills → Calculates score → Generates recommendations
```

### 4. View Results
```
Score: 85% (Good Match)
✓ Matched: Python, JavaScript, Docker (8 skills)
⚠ Missing: Kubernetes, AWS (2 skills)
💡 Recommendation: "Strong candidate. Highlight matching skills..."
```

## 🏆 Matching Algorithm

```ruby
score = (matched_skills / total_required) × 100 - (missing_skills / total_required) × 20

Levels:
- 90-100%: Excellent Match 🌟
- 70-89%:  Good Match ✅
- 50-69%:  Fair Match ⚠️
- 0-49%:   Poor Match ❌
```

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Ruby on Rails 7.1 |
| Frontend | ERB + Tailwind CSS + Turbo |
| AI/NLP | Python 3.11 + spaCy |
| API | FastAPI |
| Database | PostgreSQL 15 |
| Testing | RSpec + pytest |
| DevOps | Docker + Docker Compose |

## 📊 Project Stats

- **73 Files Created**
- **3,000+ Lines of Code**
- **20+ Python Tests** (pytest)
- **15+ Rails Tests** (RSpec)
- **6 Database Models**
- **6 Controllers**
- **15+ Views**
- **2 Services**

## 🔌 API Endpoints

### Python Service (Port 8000)

```bash
POST /extract-skills
Content-Type: application/json
{
  "text": "Senior Python developer..."
}

Response: {
  "skills": ["Python", "Django", "PostgreSQL"],
  "entities": {...},
  "summary": "..."
}
```

### Rails API (Port 3000)

```bash
GET  /jobs              # List jobs
POST /resumes           # Upload resume
POST /matches           # Create match
GET  /matches/:id       # View match results
GET  /manifest.json     # PWA manifest
GET  /service-worker.js # Service worker
```

## 🎨 Screenshots

### Home Page
Browse available jobs and upload resumes

### Job Details
View job requirements and find the best candidates

### Match Results
See detailed scoring and recommendations

## 🚢 Deployment

### Push to GitHub
```bash
./deploy.sh
```

### Environment Variables
```bash
DATABASE_URL=postgresql://user:pass@host:5432/db
PYTHON_SERVICE_URL=http://python-service:8000
SECRET_KEY_BASE=your_secret_key
RAILS_ENV=production
```

### Production Deployment
Supports Heroku, AWS, DigitalOcean, or any Docker-compatible platform.

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for your changes
4. Implement your feature
5. Run the test suite (`./run_tests.sh`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **spaCy** - Industrial-strength NLP
- **Rails** - Convention over configuration
- **FastAPI** - Modern Python web framework
- **Tailwind CSS** - Utility-first CSS

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/bholsinger09/Smart_Resume/issues)
- **Discussions**: [GitHub Discussions](https://github.com/bholsinger09/Smart_Resume/discussions)

## ⭐ Star Us!

If you find this project useful, please consider giving it a star on GitHub!

---

**Built with ❤️ using Ruby on Rails, Python, spaCy, and PostgreSQL**

[Website](https://github.com/bholsinger09/Smart_Resume) • [Documentation](GETTING_STARTED.md) • [API Reference](DEVELOPMENT.md)
