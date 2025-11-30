class Resume < ApplicationRecord
  has_one_attached :file
  has_many :resume_skills, dependent: :destroy
  has_many :skills, through: :resume_skills
  has_many :matches, dependent: :destroy
  has_many :jobs, through: :matches
  
  validates :filename, presence: true
  
  after_commit :extract_skills_async, on: :create
  
  # Status can be: pending, processing, completed, failed
  
  def extract_skills_from_python_service
    unless file.attached?
      update(
        processing_status: 'failed',
        processing_error: 'No file attached to resume'
      )
      return false
    end
    
    update(processing_status: 'processing')
    
    service = PythonSkillExtractionService.new
    result = service.extract_from_file(file)
    
    if result[:success]
      update(
        extracted_skills: result[:skills],
        entities: result[:entities],
        summary: result[:summary],
        processing_status: 'completed'
      )
      
      # Create skill associations
      result[:skills].each do |skill_name|
        skill = Skill.find_or_create_by(name: skill_name)
        resume_skills.find_or_create_by(skill: skill) unless resume_skills.exists?(skill: skill)
      end
      
      true
    else
      update(
        processing_status: 'failed',
        processing_error: result[:error]
      )
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
    return unless file.attached?
    
    begin
      extract_skills_from_python_service
    rescue ActiveStorage::FileNotFoundError => e
      update(
        processing_status: 'failed',
        processing_error: "File not found: #{e.message}"
      )
    rescue StandardError => e
      update(
        processing_status: 'failed',
        processing_error: "Error processing resume: #{e.message}"
      )
    end
  end
end
