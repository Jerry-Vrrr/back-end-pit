class CallRailService
  include HTTParty
  base_uri 'https://api.callrail.com/v3/a'

  # Initialize with API key and company key
  def initialize(api_key = '53962143e3bd0ab2989770ecbe94a75c', company_key = nil)
    @api_key = api_key
    @company_id = company_key  # company_key should directly represent the company_id in your COMPANY_MAPPING
  end

  # Fetch call data from CallRail API
  def fetch_calls
    # Construct the API endpoint URL with the company ID
    url = "/587877488/calls.json?company_id=#{@company_id}"
    options = { headers: { "Authorization" => "Token token=#{@api_key}" } }    
    
    # Log the request details
    Rails.logger.info "Requesting URL: #{self.class.base_uri + url} with options: #{options}"
    
    # Perform the GET request to CallRail API
    response = self.class.get(url, options)
    
    # Log response details
    Rails.logger.info "Response code: #{response.code}"
    Rails.logger.info "Response body: #{response.body}"
    
    response
  end
end
