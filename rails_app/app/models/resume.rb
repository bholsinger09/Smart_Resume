class Resume < ApplicationRecord
  has_one_attached :file
  has_many :resume_skills, dependent: :destroy
  has_many :skills, through: :resume_skills
  has_many :matches, dependent: :destroy
  has_many :jobs, through: :matches
  
  validates :filename, presence: true
  
  after_create :extract_skills_async
  
  def extract_skills_from_python_service
    return unless file.attached?
    
    service = PythonSkillExtractionService.new
    result = service.extract_from_file(file)
    
    if result[:success]
      update(
        extracted_skills: result[:skills],
        entities: result[:entities],
        summary: result[:summary]
      )
      
      # Create skill associations
      result[:skills].each do |skill_name|
        skill = Skill.find_or_create_by(name: skill_name)
        resume_skills.find_or_create_by(skill: skill) unless resume_skills.exists?(skill: skill)
      end
      
      true
    else
      errors.add(:base, "Failed to extract skills: #{result[:error]}")
      false
    end
  end
  
  def skill_names
    extracted_skills || []
  end
  
  private
  
  def extract_skills_async
    # In a real application, this would be a background job
    extract_skills_from_python_service if file.attached?
  end
end
