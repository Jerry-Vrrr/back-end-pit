Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3001', 'https://the-apricot-pit.netlify.app' # Add your deployed frontend domain here
    resource '*',
      headers: :any,
      expose: ['X-Session-Token'], # Make sure to expose the custom header
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
