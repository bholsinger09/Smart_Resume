# SmartResume Development Guide

## Project Overview

SmartResume is a Progressive Web Application that helps job seekers match their resumes with job descriptions using AI-powered skill extraction.

### Architecture

```
┌─────────────────┐
│   Rails Frontend │ (PWA with service worker)
│   & API Server   │
└────────┬─────────┘
         │
         │ HTTP API calls
         │
┌────────▼─────────┐
│ Python FastAPI   │ (spaCy for NLP)
│ Skill Extraction │
└──────────────────┘
```

## Technology Stack

### Backend
- **Rails 7.1**: Main application server, UI, job management, matching logic
- **PostgreSQL**: Database for jobs, resumes, skills, and matches
- **Redis**: Caching and background jobs (optional)

### Microservice
- **Python FastAPI**: RESTful API for skill extraction
- **spaCy**: Natural Language Processing for resume parsing
- **PyPDF2**: PDF text extraction
- **python-docx**: DOCX text extraction

### Frontend
- **Tailwind CSS**: Utility-first CSS framework
- **Turbo**: Fast page transitions
- **Stimulus**: JavaScript framework
- **Service Worker**: PWA offline capabilities

## Development Setup

### Prerequisites
- Ruby 3.2.2
- Python 3.9+
- PostgreSQL 15
- Node.js 18+

### Quick Start (Docker)

```bash
chmod +x setup.sh
./setup.sh
```

### Manual Setup

#### 1. Python Service

```bash
cd python_service
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python -m spacy download en_core_web_sm
uvicorn app:app --reload --port 8000
```

#### 2. Rails Application

```bash
cd rails_app
bundle install
rails db:create db:migrate db:seed
rails server -p 3000
```

## Testing

### Run All Tests

```bash
chmod +x run_tests.sh
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

### Test Coverage

```bash
# Python coverage
cd python_service
pytest --cov=. --cov-report=html

# Rails coverage (included in rspec with simplecov)
cd rails_app
bundle exec rspec
open coverage/index.html
```

## API Documentation

### Python Service Endpoints

#### POST `/extract-skills`
Extract skills from text input.

**Request:**
```json
{
  "text": "Senior Python developer with Django experience..."
}
```

**Response:**
```json
{
  "skills": ["Python", "Django", "PostgreSQL"],
  "entities": {
    "ORG": ["Google"],
    "PERSON": ["John Doe"]
  },
  "summary": "Senior Python developer with..."
}
```

#### POST `/extract-skills-from-file`
Extract skills from uploaded file (PDF, DOCX, TXT).

**Request:** multipart/form-data with file

**Response:** Same as `/extract-skills`

### Rails API Endpoints

#### GET `/api/v1/jobs`
List all active jobs.

#### POST `/api/v1/resumes`
Upload a resume.

#### POST `/api/v1/match`
Create a match between resume and job.

## Database Schema

### Key Models

- **Job**: Job postings with requirements
- **Resume**: Uploaded resumes with extracted skills
- **Skill**: Technology skills and competencies
- **Match**: Resume-to-job matches with scores
- **JobSkill**: Join table for job requirements
- **ResumeSkill**: Join table for resume skills

### Relationships

```
Job ─┬─ JobSkill ─── Skill
     └─ Match ─── Resume ─── ResumeSkill ─── Skill
```

## Matching Algorithm

The matching algorithm compares resume skills against job requirements:

1. **Skill Extraction**: Python service extracts skills from resume
2. **Normalization**: Skills are normalized (lowercase, trimmed)
3. **Comparison**: Resume skills matched against job requirements
4. **Scoring**:
   - Base score: (matched_skills / total_required_skills) × 100
   - Penalty: Missing skills reduce score by up to 20%
   - Final score: Clamped between 0-100

5. **Recommendations**: Generated based on:
   - Matched skills
   - Missing skills
   - Score level (Excellent, Good, Fair, Poor)

## PWA Features

### Service Worker
- Caches key routes for offline access
- Serves cached content when network unavailable
- Updates cache on new deployments

### Manifest
- App name, icons, theme color
- Standalone display mode
- Installable on mobile/desktop

## Deployment

### Environment Variables

```bash
# Rails
DATABASE_URL=postgresql://user:pass@host:5432/db
PYTHON_SERVICE_URL=http://python-service:8000
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key

# Python
ENVIRONMENT=production
```

### Production Deployment

1. Build Docker images
2. Deploy to container orchestration (Kubernetes, ECS, etc.)
3. Set up database migrations
4. Configure environment variables
5. Set up SSL certificates
6. Configure CDN for assets

## Troubleshooting

### Common Issues

**Python service not extracting skills:**
- Ensure spaCy model is downloaded: `python -m spacy download en_core_web_sm`
- Check Python service logs: `docker-compose logs python_service`

**Rails can't connect to Python service:**
- Verify `PYTHON_SERVICE_URL` environment variable
- Check network connectivity between services

**Database connection errors:**
- Ensure PostgreSQL is running
- Verify database credentials in `database.yml`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new features
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details
