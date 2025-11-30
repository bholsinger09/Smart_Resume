class PwaController < ApplicationController
  def manifest
    render json: {
      name: 'SmartResume',
      short_name: 'SmartResume',
      description: 'AI-powered resume matching application',
      start_url: '/',
      display: 'standalone',
      background_color: '#ffffff',
      theme_color: '#3b82f6',
      icons: [
        {
          src: '/icon-192.png',
          sizes: '192x192',
          type: 'image/png',
          purpose: 'any maskable'
        },
        {
          src: '/icon-512.png',
          sizes: '512x512',
          type: 'image/png',
          purpose: 'any maskable'
        }
      ]
    }
  end
  
  def service_worker
    render template: 'pwa/service_worker', content_type: 'application/javascript'
  end
  
  def offline
    render template: 'pwa/offline'
  end
end
