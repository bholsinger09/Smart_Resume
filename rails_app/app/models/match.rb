class Match < ApplicationRecord
  belongs_to :resume
  belongs_to :job
  
  validates :resume_id, uniqueness: { scope: :job_id }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  before_validation :calculate_match_score, if: :new_record?
  
  scope :high_matches, -> { where('score >= ?', 70) }
  scope :by_score, -> { order(score: :desc) }
  
  def calculate_match_score
    matcher = JobMatchingService.new(resume, job)
    result = matcher.calculate_match
    
    self.score = result[:score]
    self.matched_skills = result[:matched_skills]
    self.missing_skills = result[:missing_skills]
    self.recommendations = result[:recommendations]
  end
  
  def match_percentage
    "#{score.round}%"
  end
  
  def match_level
    case score
    when 90..100 then 'Excellent'
    when 70..89 then 'Good'
    when 50..69 then 'Fair'
    else 'Poor'
    end
  end
end
