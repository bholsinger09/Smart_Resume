require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SmartResume
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties goes here.
    config.api_only = false
    
    # Python service configuration
    config.python_service_url = ENV.fetch('PYTHON_SERVICE_URL', 'http://localhost:8000')
    
    # Active Storage configuration
    config.active_storage.variant_processor = :mini_magick
  end
end
