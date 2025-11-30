class Job < ApplicationRecord
  has_many :job_skills, dependent: :destroy
  has_many :skills, through: :job_skills
  has_many :matches, dependent: :destroy
  has_many :resumes, through: :matches
  
  validates :title, presence: true
  validates :company, presence: true
  validates :description, presence: true
  
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Extract skills from job description and requirements
  def extract_required_skills
    text = [description, requirements].compact.join(' ')
    skill_names = text.scan(/\b(?:Python|Java|JavaScript|TypeScript|Ruby|Rails|Django|React|Angular|Vue|AWS|Docker|Kubernetes|PostgreSQL|MySQL|MongoDB|Git|Agile|TDD|CI\/CD)\b/i).uniq
    
    skill_names.each do |name|
      skill = Skill.find_or_create_by(name: name.titleize)
      job_skills.find_or_create_by(skill: skill, required: true) unless job_skills.exists?(skill: skill)
    end
  end
  
  def required_skills
    job_skills.where(required: true).map(&:skill)
  end
  
  def skill_names
    skills.pluck(:name)
  end
end
