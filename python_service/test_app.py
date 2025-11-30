import pytest
from fastapi.testclient import TestClient
from app import app, extract_skills_with_nlp, extract_entities, generate_summary
from io import BytesIO

client = TestClient(app)


class TestHealthEndpoints:
    """Test health and status endpoints."""
    
    def test_root_endpoint(self):
        """Test root endpoint returns correct message."""
        response = client.get("/")
        assert response.status_code == 200
        assert "status" in response.json()
        assert response.json()["status"] == "running"
    
    def test_health_check(self):
        """Test health check endpoint."""
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json()["status"] == "healthy"


class TestSkillExtraction:
    """Test skill extraction functionality."""
    
    def test_extract_skills_from_text(self):
        """Test extracting skills from text input."""
        sample_text = """
        Senior Software Engineer with 5 years of experience in Python, JavaScript, and Ruby.
        Expert in Django, React, and Rails frameworks. Proficient in AWS, Docker, and PostgreSQL.
        Strong background in Agile development and TDD practices.
        """
        
        response = client.post(
            "/extract-skills",
            json={"text": sample_text}
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "skills" in data
        assert "entities" in data
        assert "summary" in data
        assert len(data["skills"]) > 0
        
        # Check for expected skills
        skills_lower = [s.lower() for s in data["skills"]]
        assert any("python" in s for s in skills_lower)
        assert any("javascript" in s for s in skills_lower)
    
    def test_extract_skills_empty_text(self):
        """Test extraction fails with empty text."""
        response = client.post(
            "/extract-skills",
            json={"text": ""}
        )
        
        assert response.status_code == 400
        assert "empty" in response.json()["detail"].lower()
    
    def test_extract_skills_with_technical_terms(self):
        """Test extraction of technical skills."""
        text = "Experienced in React, TypeScript, PostgreSQL, AWS, Kubernetes, and CI/CD pipelines."
        
        skills = extract_skills_with_nlp(text)
        
        assert len(skills) > 0
        skills_lower = [s.lower() for s in skills]
        assert any("react" in s for s in skills_lower)
        assert any("typescript" in s for s in skills_lower)


class TestEntityExtraction:
    """Test named entity extraction."""
    
    def test_extract_entities(self):
        """Test entity extraction from resume text."""
        text = """
        John Doe worked at Google and Microsoft. He has a degree from MIT.
        Experienced with Python and JavaScript development.
        """
        
        entities = extract_entities(text)
        
        assert isinstance(entities, dict)
        assert len(entities) > 0
        
        # Check for organization entities
        if "ORG" in entities:
            orgs = [e.lower() for e in entities["ORG"]]
            assert any("google" in o or "microsoft" in o for o in orgs)


class TestSummaryGeneration:
    """Test summary generation."""
    
    def test_generate_summary(self):
        """Test summary generation from text."""
        text = """
        Experienced software engineer with expertise in full-stack development.
        Specializes in Python and JavaScript frameworks. Built scalable applications.
        Led teams of 5+ developers. Increased system performance by 50%.
        """
        
        summary = generate_summary(text)
        
        assert isinstance(summary, str)
        assert len(summary) > 0
        assert len(summary) <= 500
    
    def test_generate_summary_short_text(self):
        """Test summary generation with short text."""
        text = "Software Engineer."
        
        summary = generate_summary(text)
        
        assert isinstance(summary, str)
        assert len(summary) > 0


class TestFileUpload:
    """Test file upload and processing."""
    
    def test_upload_txt_file(self):
        """Test uploading a TXT file."""
        content = b"Python Developer with Django and PostgreSQL experience."
        
        response = client.post(
            "/extract-skills-from-file",
            files={"file": ("resume.txt", BytesIO(content), "text/plain")}
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "skills" in data
        assert len(data["skills"]) > 0
    
    def test_upload_unsupported_format(self):
        """Test uploading unsupported file format."""
        content = b"Some content"
        
        response = client.post(
            "/extract-skills-from-file",
            files={"file": ("resume.xyz", BytesIO(content), "application/octet-stream")}
        )
        
        assert response.status_code == 400
        assert "unsupported" in response.json()["detail"].lower()


class TestIntegration:
    """Integration tests for complete workflows."""
    
    def test_full_extraction_workflow(self):
        """Test complete skill extraction workflow."""
        resume_text = """
        JOHN DOE
        Senior Full-Stack Developer
        
        SUMMARY
        Experienced software engineer with 8 years in web development.
        Specialized in Python, JavaScript, and cloud technologies.
        
        SKILLS
        - Languages: Python, JavaScript, TypeScript, Ruby
        - Frameworks: Django, React, Rails, FastAPI
        - Databases: PostgreSQL, MongoDB, Redis
        - Cloud: AWS, Docker, Kubernetes
        - Practices: Agile, TDD, CI/CD
        
        EXPERIENCE
        Senior Developer at Google (2020-Present)
        - Built scalable microservices using Python and Docker
        - Led team of 5 developers using Agile methodologies
        """
        
        response = client.post(
            "/extract-skills",
            json={"text": resume_text}
        )
        
        assert response.status_code == 200
        data = response.json()
        
        # Verify all components
        assert len(data["skills"]) >= 5
        assert len(data["summary"]) > 0
        assert isinstance(data["entities"], dict)
        
        # Verify key skills are extracted
        skills_lower = [s.lower() for s in data["skills"]]
        expected_skills = ["python", "javascript", "docker", "aws"]
        found_skills = sum(1 for skill in expected_skills if any(skill in s for s in skills_lower))
        assert found_skills >= 2, f"Expected to find at least 2 of {expected_skills}"
