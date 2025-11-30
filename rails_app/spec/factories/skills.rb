FactoryBot.define do
  factory :skill do
    sequence(:name) { |n| "Skill#{n}" }
    category { "Technical" }
    description { "A technical skill" }
    
    trait :python do
      name { "Python" }
    end
    
    trait :javascript do
      name { "JavaScript" }
    end
    
    trait :ruby do
      name { "Ruby" }
    end
  end
end
