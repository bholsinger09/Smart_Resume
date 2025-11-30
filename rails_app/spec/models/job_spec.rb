require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { should have_many(:job_skills).dependent(:destroy) }
    it { should have_many(:skills).through(:job_skills) }
    it { should have_many(:matches).dependent(:destroy) }
    it { should have_many(:resumes).through(:matches) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:description) }
  end
  
  describe 'scopes' do
    let!(:active_job) { create(:job, active: true) }
    let!(:inactive_job) { create(:job, active: false) }
    
    it 'returns only active jobs' do
      expect(Job.active).to include(active_job)
      expect(Job.active).not_to include(inactive_job)
    end
    
    it 'returns recent jobs first' do
      older_job = create(:job, created_at: 2.days.ago)
      newer_job = create(:job, created_at: 1.day.ago)
      
      expect(Job.recent.first).to eq(newer_job)
    end
  end
  
  describe '#extract_required_skills' do
    it 'extracts skills from description' do
      job = create(:job, description: 'We need Python and JavaScript developers')
      job.extract_required_skills
      
      expect(job.skills.pluck(:name)).to include('Python', 'Javascript')
    end
  end
  
  describe '#skill_names' do
    it 'returns array of skill names' do
      job = create(:job, :with_skills)
      
      expect(job.skill_names).to be_an(Array)
      expect(job.skill_names).to include('Python', 'Ruby')
    end
  end
end
