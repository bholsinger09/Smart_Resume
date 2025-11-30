FactoryBot.define do
  factory :match do
    association :resume
    association :job
    score { 75.5 }
    matched_skills { ["Python", "JavaScript"] }
    missing_skills { ["Ruby", "Rails"] }
    recommendations { "Good match! Consider learning Ruby and Rails." }
  end
end
