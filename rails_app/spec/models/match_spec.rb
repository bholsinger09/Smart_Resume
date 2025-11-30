require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'associations' do
    it { should belong_to(:resume) }
    it { should belong_to(:job) }
  end
  
  describe 'validations' do
    subject { create(:match) }
    
    it { should validate_presence_of(:score) }
    it { should validate_numericality_of(:score).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
    it { should validate_uniqueness_of(:resume_id).scoped_to(:job_id) }
  end
  
  describe '#match_percentage' do
    it 'returns formatted percentage' do
      match = build(:match, score: 75.5)
      
      expect(match.match_percentage).to eq('76%')
    end
  end
  
  describe '#match_level' do
    it 'returns Excellent for scores 90+' do
      match = build(:match, score: 95)
      expect(match.match_level).to eq('Excellent')
    end
    
    it 'returns Good for scores 70-89' do
      match = build(:match, score: 80)
      expect(match.match_level).to eq('Good')
    end
    
    it 'returns Fair for scores 50-69' do
      match = build(:match, score: 60)
      expect(match.match_level).to eq('Fair')
    end
    
    it 'returns Poor for scores below 50' do
      match = build(:match, score: 40)
      expect(match.match_level).to eq('Poor')
    end
  end
end
