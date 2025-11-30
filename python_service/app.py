from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict
import spacy
from io import BytesIO
import PyPDF2
import docx
import re

app = FastAPI(title="SmartResume Skill Extractor")

# CORS middleware for Rails integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load spaCy model
try:
    nlp = spacy.load("en_core_web_sm")
except OSError:
    print("Downloading spaCy model...")
    import subprocess
    subprocess.run(["python", "-m", "spacy", "download", "en_core_web_sm"])
    nlp = spacy.load("en_core_web_sm")


class TextInput(BaseModel):
    text: str


class SkillsResponse(BaseModel):
    skills: List[str]
    entities: Dict[str, List[str]]
    summary: str


# Common technical skills and patterns
SKILL_PATTERNS = [
    r'\b(?:Python|Java|JavaScript|TypeScript|Ruby|Go|Rust|C\+\+|C#|PHP|Swift|Kotlin)\b',
    r'\b(?:React|Angular|Vue|Django|Flask|Rails|Spring|Express|FastAPI)\b',
    r'\b(?:AWS|Azure|GCP|Docker|Kubernetes|Jenkins|GitLab|CircleCI)\b',
    r'\b(?:PostgreSQL|MySQL|MongoDB|Redis|Elasticsearch|Cassandra)\b',
    r'\b(?:Git|Agile|Scrum|TDD|CI/CD|DevOps|Machine Learning|AI)\b',
    r'\b(?:HTML|CSS|SQL|REST|GraphQL|gRPC|WebSocket)\b',
    r'\b(?:Linux|Unix|Windows|macOS|Android|iOS)\b',
]


def extract_text_from_pdf(file_bytes: bytes) -> str:
    """Extract text from PDF file."""
    pdf_reader = PyPDF2.PdfReader(BytesIO(file_bytes))
    text = ""
    for page in pdf_reader.pages:
        text += page.extract_text()
    return text


def extract_text_from_docx(file_bytes: bytes) -> str:
    """Extract text from DOCX file."""
    doc = docx.Document(BytesIO(file_bytes))
    return "\n".join([paragraph.text for paragraph in doc.paragraphs])


def extract_skills_with_nlp(text: str) -> List[str]:
    """Extract skills using spaCy NLP and pattern matching."""
    skills = set()
    
    # Pattern-based extraction for technical skills
    for pattern in SKILL_PATTERNS:
        matches = re.findall(pattern, text, re.IGNORECASE)
        skills.update([match.strip() for match in matches])
    
    # spaCy entity recognition
    doc = nlp(text)
    
    # Extract skills from noun chunks that might be technologies
    for chunk in doc.noun_chunks:
        chunk_text = chunk.text.strip()
        # Filter for potential technical terms (uppercase or mixed case)
        if len(chunk_text) > 2 and (chunk_text[0].isupper() or 'development' in chunk_text.lower() or 'programming' in chunk_text.lower()):
            skills.add(chunk_text)
    
    # Extract organizations and products (often technologies/tools)
    for ent in doc.ents:
        if ent.label_ in ["ORG", "PRODUCT", "GPE"]:
            skills.add(ent.text.strip())
    
    return sorted(list(skills))


def extract_entities(text: str) -> Dict[str, List[str]]:
    """Extract named entities from text."""
    doc = nlp(text)
    entities = {}
    
    for ent in doc.ents:
        if ent.label_ not in entities:
            entities[ent.label_] = []
        entities[ent.label_].append(ent.text)
    
    return entities


def generate_summary(text: str) -> str:
    """Generate a brief summary of the resume."""
    doc = nlp(text)
    
    # Extract first few sentences as summary
    sentences = [sent.text.strip() for sent in doc.sents]
    summary = " ".join(sentences[:3]) if sentences else "No summary available."
    
    return summary[:500]  # Limit to 500 characters


@app.get("/")
async def root():
    """Root endpoint."""
    return {"message": "SmartResume Skill Extraction Service", "status": "running"}


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}


@app.post("/extract-skills", response_model=SkillsResponse)
async def extract_skills_from_text(input_data: TextInput):
    """Extract skills from provided text."""
    try:
        text = input_data.text
        
        if not text or len(text.strip()) == 0:
            raise HTTPException(status_code=400, detail="Text cannot be empty")
        
        skills = extract_skills_with_nlp(text)
        entities = extract_entities(text)
        summary = generate_summary(text)
        
        return SkillsResponse(
            skills=skills,
            entities=entities,
            summary=summary
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing text: {str(e)}")


@app.post("/extract-skills-from-file", response_model=SkillsResponse)
async def extract_skills_from_file(file: UploadFile = File(...)):
    """Extract skills from uploaded resume file (PDF, DOCX, or TXT)."""
    try:
        file_bytes = await file.read()
        
        # Extract text based on file type
        if file.filename.lower().endswith('.pdf'):
            text = extract_text_from_pdf(file_bytes)
        elif file.filename.lower().endswith('.docx'):
            text = extract_text_from_docx(file_bytes)
        elif file.filename.lower().endswith('.txt'):
            text = file_bytes.decode('utf-8')
        else:
            raise HTTPException(
                status_code=400,
                detail="Unsupported file format. Please upload PDF, DOCX, or TXT file."
            )
        
        if not text or len(text.strip()) == 0:
            raise HTTPException(status_code=400, detail="Could not extract text from file")
        
        skills = extract_skills_with_nlp(text)
        entities = extract_entities(text)
        summary = generate_summary(text)
        
        return SkillsResponse(
            skills=skills,
            entities=entities,
            summary=summary
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing file: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
