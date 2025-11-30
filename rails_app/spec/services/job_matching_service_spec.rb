require 'rails_helper'

RSpec.describe JobMatchingService do
  let(:resume) { create(:resume, :with_skills, extracted_skills: ['Python', 'JavaScript', 'Docker', 'PostgreSQL']) }
  let(:job) { create(:job, :with_skills) }
  let(:service) { described_class.new(resume, job) }
  
  describe '#calculate_match' do
    it 'returns match results' do
      result = service.calculate_match
      
      expect(result).to have_key(:score)
      expect(result).to have_key(:matched_skills)
      expect(result).to have_key(:missing_skills)
      expect(result).to have_key(:recommendations)
    end
    
    it 'calculates correct score for perfect match' do
      resume = create(:resume, extracted_skills: ['Python', 'Ruby', 'Rails', 'JavaScript'])
      job = create(:job, :with_skills)
      service = described_class.new(resume, job)
      
      result = service.calculate_match
      
      expect(result[:score]).to be > 70
      expect(result[:matched_skills].size).to be > 0
    end
    
    it 'identifies missing skills' do
      resume = create(:resume, extracted_skills: ['Python'])
      job = create(:job, :with_skills)
      service = described_class.new(resume, job)
      
      result = service.calculate_match
      
      expect(result[:missing_skills].size).to be > 0
    end
    
    it 'generates recommendations' do
      result = service.calculate_match
      
      expect(result[:recommendations]).to be_a(String)
      expect(result[:recommendations]).not_to be_empty
    end
  end
end
