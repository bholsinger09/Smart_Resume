# Create sample skills
puts "Creating skills..."
skills_data = [
  { name: 'Python', category: 'Programming Language' },
  { name: 'JavaScript', category: 'Programming Language' },
  { name: 'Ruby', category: 'Programming Language' },
  { name: 'TypeScript', category: 'Programming Language' },
  { name: 'Java', category: 'Programming Language' },
  { name: 'Go', category: 'Programming Language' },
  { name: 'Rails', category: 'Framework' },
  { name: 'Django', category: 'Framework' },
  { name: 'React', category: 'Framework' },
  { name: 'Angular', category: 'Framework' },
  { name: 'Vue', category: 'Framework' },
  { name: 'FastAPI', category: 'Framework' },
  { name: 'PostgreSQL', category: 'Database' },
  { name: 'MySQL', category: 'Database' },
  { name: 'MongoDB', category: 'Database' },
  { name: 'Redis', category: 'Database' },
  { name: 'Docker', category: 'DevOps' },
  { name: 'Kubernetes', category: 'DevOps' },
  { name: 'AWS', category: 'Cloud' },
  { name: 'Azure', category: 'Cloud' },
  { name: 'GCP', category: 'Cloud' },
  { name: 'Git', category: 'Tools' },
  { name: 'Agile', category: 'Methodology' },
  { name: 'TDD', category: 'Methodology' },
  { name: 'CI/CD', category: 'DevOps' }
]

skills_data.each do |skill_data|
  Skill.find_or_create_by(name: skill_data[:name]) do |skill|
    skill.category = skill_data[:category]
  end
end

puts "Created #{Skill.count} skills"

# Create sample jobs
puts "Creating sample jobs..."

job1 = Job.create!(
  title: 'Senior Full-Stack Developer',
  company: 'TechCorp Inc.',
  description: <<~DESC,
    We are looking for an experienced full-stack developer to join our growing team.
    You will work on building scalable web applications using modern technologies.
    
    Responsibilities:
    - Design and develop web applications
    - Write clean, maintainable code
    - Collaborate with cross-functional teams
    - Mentor junior developers
  DESC
  requirements: <<~REQ,
    - 5+ years of professional software development experience
    - Strong proficiency in Python and JavaScript
    - Experience with React and Django frameworks
    - Knowledge of PostgreSQL and Docker
    - Excellent problem-solving skills
  REQ
  location: 'San Francisco, CA (Remote)',
  employment_type: 'Full-time',
  salary_min: 140000,
  salary_max: 200000,
  active: true
)

['Python', 'JavaScript', 'React', 'Django', 'PostgreSQL', 'Docker'].each do |skill_name|
  skill = Skill.find_by(name: skill_name)
  job1.job_skills.create!(skill: skill, required: true, importance: 5) if skill
end

job2 = Job.create!(
  title: 'DevOps Engineer',
  company: 'CloudScale Systems',
  description: <<~DESC,
    Join our DevOps team to help build and maintain our cloud infrastructure.
    You will work with cutting-edge technologies to ensure our systems are
    reliable, scalable, and secure.
  DESC
  requirements: <<~REQ,
    - 3+ years of DevOps experience
    - Strong knowledge of AWS and Kubernetes
    - Experience with Docker and CI/CD pipelines
    - Proficiency in Python or Go
    - Understanding of infrastructure as code
  REQ
  location: 'Austin, TX',
  employment_type: 'Full-time',
  salary_min: 120000,
  salary_max: 170000,
  active: true
)

['AWS', 'Kubernetes', 'Docker', 'Python', 'CI/CD', 'Git'].each do |skill_name|
  skill = Skill.find_by(name: skill_name)
  job2.job_skills.create!(skill: skill, required: true, importance: 5) if skill
end

job3 = Job.create!(
  title: 'Frontend Developer',
  company: 'DesignHub',
  description: <<~DESC,
    We need a talented frontend developer to create beautiful and responsive
    user interfaces. You'll work closely with our design team to bring
    mockups to life.
  DESC
  requirements: <<~REQ,
    - 2+ years of frontend development experience
    - Expert knowledge of JavaScript, TypeScript, and React
    - Strong understanding of HTML and CSS
    - Experience with modern build tools
    - Eye for design and user experience
  REQ
  location: 'New York, NY (Hybrid)',
  employment_type: 'Full-time',
  salary_min: 100000,
  salary_max: 150000,
  active: true
)

['JavaScript', 'TypeScript', 'React', 'Git'].each do |skill_name|
  skill = Skill.find_by(name: skill_name)
  job3.job_skills.create!(skill: skill, required: true, importance: 5) if skill
end

job4 = Job.create!(
  title: 'Ruby on Rails Developer',
  company: 'StartupXYZ',
  description: <<~DESC,
    Looking for a Rails developer to help build our MVP and grow with the company.
    Great opportunity to work on greenfield projects and make architectural decisions.
  DESC
  requirements: <<~REQ,
    - 3+ years of Ruby on Rails experience
    - Strong knowledge of PostgreSQL
    - Experience with Agile development
    - TDD/BDD experience
    - Good communication skills
  REQ
  location: 'Remote',
  employment_type: 'Full-time',
  salary_min: 110000,
  salary_max: 160000,
  active: true
)

['Ruby', 'Rails', 'PostgreSQL', 'Agile', 'TDD', 'Git'].each do |skill_name|
  skill = Skill.find_by(name: skill_name)
  job4.job_skills.create!(skill: skill, required: true, importance: 5) if skill
end

puts "Created #{Job.count} jobs with associated skills"
puts "Seed data complete!"
