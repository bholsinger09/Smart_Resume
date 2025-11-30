FactoryBot.define do
  factory :job do
    title { "Senior Software Engineer" }
    company { "Tech Corp" }
    description { "We are looking for an experienced software engineer..." }
    requirements { "5+ years of experience in Ruby on Rails, Python, and JavaScript" }
    location { "San Francisco, CA" }
    employment_type { "Full-time" }
    salary_min { 120000 }
    salary_max { 180000 }
    active { true }
    
    trait :with_skills do
      after(:create) do |job|
        ['Python', 'Ruby', 'Rails', 'JavaScript'].each do |skill_name|
          skill = Skill.find_or_create_by(name: skill_name)
          job.job_skills.create(skill: skill, required: true)
        end
      end
    end
    
    trait :inactive do
      active { false }
    end
  end
end
