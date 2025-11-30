class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def health
    python_healthy = PythonSkillExtractionService.new.health_check
    
    render json: {
      status: 'healthy',
      services: {
        rails: 'healthy',
        python: python_healthy ? 'healthy' : 'unhealthy',
        database: database_healthy? ? 'healthy' : 'unhealthy'
      }
    }
  end
  
  private
  
  def database_healthy?
    ActiveRecord::Base.connection.active?
  rescue StandardError
    false
  end
end
