FactoryBot.define do
  factory :resume do
    filename { "john_doe_resume.pdf" }
    content_type { "application/pdf" }
    extracted_text { "John Doe\nSoftware Engineer\nSkills: Python, JavaScript, React, Docker" }
    summary { "Experienced software engineer with 5 years of experience" }
    extracted_skills { ["Python", "JavaScript", "React", "Docker", "PostgreSQL"] }
    entities { { "PERSON" => ["John Doe"], "ORG" => ["Google"] } }
    
    trait :with_skills do
      after(:create) do |resume|
        resume.extracted_skills.each do |skill_name|
          skill = Skill.find_or_create_by(name: skill_name)
          resume.resume_skills.create(skill: skill)
        end
      end
    end
    
    trait :without_skills do
      extracted_skills { [] }
      summary { nil }
    end
  end
end
