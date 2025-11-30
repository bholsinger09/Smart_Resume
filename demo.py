#!/usr/bin/env python3
"""
SmartResume Demo - Skill Extraction Simulation
This demonstrates the core matching logic without requiring external dependencies.
"""

import re
import json
from typing import List, Dict, Set


class SkillExtractor:
    """Simulates the spaCy skill extraction"""
    
    SKILL_PATTERNS = [
        r'\b(?:Python|Java|JavaScript|TypeScript|Ruby|Go|Rust|C\+\+|C#|PHP|Swift|Kotlin)\b',
        r'\b(?:React|Angular|Vue|Django|Flask|Rails|Spring|Express|FastAPI)\b',
        r'\b(?:AWS|Azure|GCP|Docker|Kubernetes|Jenkins|GitLab|CircleCI)\b',
        r'\b(?:PostgreSQL|MySQL|MongoDB|Redis|Elasticsearch|Cassandra)\b',
        r'\b(?:Git|Agile|Scrum|TDD|CI/CD|DevOps|Machine Learning|AI)\b',
    ]
    
    def extract_skills(self, text: str) -> List[str]:
        """Extract skills from text using pattern matching"""
        skills = set()
        
        for pattern in self.SKILL_PATTERNS:
            matches = re.findall(pattern, text, re.IGNORECASE)
            skills.update([match.strip().title() for match in matches])
        
        return sorted(list(skills))


class JobMatcher:
    """Simulates the Rails job matching service"""
    
    def calculate_match(self, resume_skills: List[str], job_skills: List[str]) -> Dict:
        """Calculate match score between resume and job"""
        resume_set = set(s.lower() for s in resume_skills)
        job_set = set(s.lower() for s in job_skills)
        
        matched = resume_set & job_set
        missing = job_set - resume_set
        extra = resume_set - job_set
        
        if not job_set:
            score = 0.0
        else:
            base_score = (len(matched) / len(job_set)) * 100
            penalty = (len(missing) / len(job_set)) * 20
            score = max(base_score - penalty, 0)
        
        recommendations = self._generate_recommendations(matched, missing, score)
        
        return {
            'score': round(score, 2),
            'matched_skills': sorted(list(matched)),
            'missing_skills': sorted(list(missing)),
            'extra_skills': sorted(list(extra)),
            'recommendations': recommendations,
            'match_level': self._get_match_level(score)
        }
    
    def _get_match_level(self, score: float) -> str:
        """Get match level based on score"""
        if score >= 90:
            return 'Excellent'
        elif score >= 70:
            return 'Good'
        elif score >= 50:
            return 'Fair'
        else:
            return 'Poor'
    
    def _generate_recommendations(self, matched: Set, missing: Set, score: float) -> str:
        """Generate personalized recommendations"""
        recommendations = []
        
        if matched:
            recommendations.append(
                f"Great match! You have {len(matched)} required skills."
            )
        
        if missing:
            if len(missing) <= 3:
                recommendations.append(
                    f"Consider learning: {', '.join(sorted(list(missing)))} to strengthen your application."
                )
            else:
                top_missing = sorted(list(missing))[:3]
                recommendations.append(
                    f"You're missing {len(missing)} skills. Focus on: {', '.join(top_missing)}."
                )
        else:
            recommendations.append(
                "Excellent! You have all the required skills for this position."
            )
        
        if score >= 90:
            recommendations.append("Outstanding match! Apply with confidence.")
        elif score >= 70:
            recommendations.append("Strong candidate. Highlight your matching skills in your application.")
        elif score >= 50:
            recommendations.append("Decent fit. Consider upskilling in missing areas before applying.")
        else:
            recommendations.append("This role may be a stretch. Focus on developing key missing skills.")
        
        return ' '.join(recommendations)


def demo():
    """Run a demonstration of the SmartResume matching system"""
    
    print("=" * 70)
    print("🎯 SmartResume - AI-Powered Resume Matcher DEMO")
    print("=" * 70)
    print()
    
    # Sample resume text
    resume_text = """
    John Doe
    Senior Software Engineer
    
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
    
    # Sample job description
    job_description = """
    Senior Full-Stack Developer
    
    Required Skills:
    - Python, JavaScript, React
    - PostgreSQL, Redis
    - Docker, Kubernetes
    - AWS, CI/CD, Agile
    """
    
    print("📄 RESUME ANALYSIS")
    print("-" * 70)
    print(resume_text.strip())
    print()
    
    # Extract skills from resume
    extractor = SkillExtractor()
    resume_skills = extractor.extract_skills(resume_text)
    
    print("✨ EXTRACTED SKILLS")
    print("-" * 70)
    for skill in resume_skills:
        print(f"  ✓ {skill}")
    print()
    
    print("💼 JOB DESCRIPTION")
    print("-" * 70)
    print(job_description.strip())
    print()
    
    # Extract skills from job
    job_skills = extractor.extract_skills(job_description)
    
    print("📋 REQUIRED SKILLS")
    print("-" * 70)
    for skill in job_skills:
        print(f"  • {skill}")
    print()
    
    # Calculate match
    matcher = JobMatcher()
    match_result = matcher.calculate_match(resume_skills, job_skills)
    
    print("🎯 MATCH RESULTS")
    print("=" * 70)
    print(f"Score: {match_result['score']}% ({match_result['match_level']} Match)")
    print()
    
    print("✅ MATCHED SKILLS ({})".format(len(match_result['matched_skills'])))
    print("-" * 70)
    for skill in match_result['matched_skills']:
        print(f"  ✓ {skill.title()}")
    print()
    
    if match_result['missing_skills']:
        print("⚠️  MISSING SKILLS ({})".format(len(match_result['missing_skills'])))
        print("-" * 70)
        for skill in match_result['missing_skills']:
            print(f"  ○ {skill.title()}")
        print()
    
    if match_result['extra_skills']:
        print("⭐ ADDITIONAL SKILLS ({})".format(len(match_result['extra_skills'])))
        print("-" * 70)
        for skill in match_result['extra_skills']:
            print(f"  + {skill.title()}")
        print()
    
    print("💡 RECOMMENDATIONS")
    print("-" * 70)
    print(match_result['recommendations'])
    print()
    
    print("=" * 70)
    print("✅ Demo Complete!")
    print()
    print("This demonstrates the core matching algorithm used in SmartResume.")
    print("The full application includes:")
    print("  • spaCy NLP for advanced skill extraction")
    print("  • Rails UI for job management and resume uploads")
    print("  • PostgreSQL database for storing jobs, resumes, and matches")
    print("  • PWA capabilities for offline access")
    print()
    print("To run the full application:")
    print("  1. With Docker: ./setup.sh")
    print("  2. Manual: See GETTING_STARTED.md")
    print("=" * 70)


if __name__ == "__main__":
    demo()
