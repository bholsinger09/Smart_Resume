require 'httparty'
require 'tempfile'

class PythonSkillExtractionService
  include HTTParty
  
  base_uri ENV.fetch('PYTHON_SERVICE_URL', 'http://python_service:8000')
  
  def initialize
    @options = {
      timeout: 30,
      headers: { 'Content-Type' => 'application/json' }
    }
  end
  
  def extract_from_text(text)
    response = self.class.post(
      '/extract-skills',
      body: { text: text }.to_json,
      headers: @options[:headers],
      timeout: @options[:timeout]
    )
    
    parse_response(response)
  rescue StandardError => e
    error_response(e.message)
  end
  
  def extract_from_file(file_attachment)
    # Create a temporary file from the attachment
    temp_file = Tempfile.new(['resume', File.extname(file_attachment.filename.to_s)])
    begin
      temp_file.binmode
      
      # Download the file with a timeout
      file_data = file_attachment.download
      temp_file.write(file_data)
      temp_file.rewind
      
      response = self.class.post(
        '/extract-skills-from-file',
        body: {
          file: temp_file
        },
        timeout: @options[:timeout]
      )
      
      parse_response(response)
    ensure
      temp_file.close
      temp_file.unlink
    end
  rescue StandardError => e
    error_response(e.message)
  end
  
  def health_check
    response = self.class.get('/health', timeout: 5)
    response.success? && response.parsed_response['status'] == 'healthy'
  rescue StandardError
    false
  end
  
  private
  
  def parse_response(response)
    if response.success?
      data = response.parsed_response
      {
        success: true,
        skills: data['skills'] || [],
        entities: data['entities'] || {},
        summary: data['summary'] || ''
      }
    else
      {
        success: false,
        error: response.parsed_response['detail'] || 'Unknown error',
        status: response.code
      }
    end
  end
  
  def error_response(message)
    {
      success: false,
      error: message,
      skills: [],
      entities: {},
      summary: ''
    }
  end
end
