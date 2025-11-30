require 'rails_helper'

RSpec.describe PythonSkillExtractionService do
  let(:service) { described_class.new }
  
  describe '#extract_from_text', :vcr do
    it 'extracts skills from text successfully' do
      text = "Senior Python developer with experience in Django and PostgreSQL"
      
      stub_request(:post, "#{ENV.fetch('PYTHON_SERVICE_URL', 'http://localhost:8000')}/extract-skills")
        .with(body: { text: text }.to_json)
        .to_return(
          status: 200,
          body: {
            skills: ['Python', 'Django', 'PostgreSQL'],
            entities: { 'PRODUCT' => ['Django', 'PostgreSQL'] },
            summary: 'Senior Python developer with experience'
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      
      result = service.extract_from_text(text)
      
      expect(result[:success]).to be true
      expect(result[:skills]).to include('Python', 'Django', 'PostgreSQL')
    end
    
    it 'handles errors gracefully' do
      stub_request(:post, "#{ENV.fetch('PYTHON_SERVICE_URL', 'http://localhost:8000')}/extract-skills")
        .to_return(status: 500)
      
      result = service.extract_from_text("test")
      
      expect(result[:success]).to be false
      expect(result[:error]).to be_present
    end
  end
  
  describe '#health_check' do
    it 'returns true when service is healthy' do
      stub_request(:get, "#{ENV.fetch('PYTHON_SERVICE_URL', 'http://localhost:8000')}/health")
        .to_return(
          status: 200,
          body: { status: 'healthy' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      
      expect(service.health_check).to be true
    end
    
    it 'returns false when service is down' do
      stub_request(:get, "#{ENV.fetch('PYTHON_SERVICE_URL', 'http://localhost:8000')}/health")
        .to_timeout
      
      expect(service.health_check).to be false
    end
  end
end
