class Skill < ApplicationRecord
  has_many :job_skills, dependent: :destroy
  has_many :jobs, through: :job_skills
  has_many :resume_skills, dependent: :destroy
  has_many :resumes, through: :resume_skills
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  before_validation :normalize_name
  
  scope :by_category, ->(category) { where(category: category) }
  scope :popular, -> { joins(:resume_skills).group(:id).order('COUNT(resume_skills.id) DESC') }
  
  private
  
  def normalize_name
    self.name = name.strip.titleize if name.present?
  end
end
