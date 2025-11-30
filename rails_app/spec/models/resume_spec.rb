require 'rails_helper'

RSpec.describe Resume, type: :model do
  describe 'associations' do
    it { should have_many(:resume_skills).dependent(:destroy) }
    it { should have_many(:skills).through(:resume_skills) }
    it { should have_many(:matches).dependent(:destroy) }
    it { should have_many(:jobs).through(:matches) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:filename) }
  end
  
  describe '#skill_names' do
    it 'returns extracted skills' do
      resume = create(:resume, extracted_skills: ['Python', 'JavaScript'])
      
      expect(resume.skill_names).to eq(['Python', 'JavaScript'])
    end
    
    it 'returns empty array when no skills' do
      resume = create(:resume, extracted_skills: nil)
      
      expect(resume.skill_names).to eq([])
    end
  end
end
