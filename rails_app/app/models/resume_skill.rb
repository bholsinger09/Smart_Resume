class ResumeSkill < ApplicationRecord
  belongs_to :resume
  belongs_to :skill
  
  validates :resume_id, uniqueness: { scope: :skill_id }
end
