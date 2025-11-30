class JobSkill < ApplicationRecord
  belongs_to :job
  belongs_to :skill
  
  validates :job_id, uniqueness: { scope: :skill_id }
  validates :importance, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
