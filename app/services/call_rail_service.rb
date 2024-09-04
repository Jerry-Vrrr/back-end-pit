class CallRailService
  include HTTParty
  base_uri 'https://api.callrail.com/v3/a'

  def initialize(api_key = ENV['CALLRAIL_API_KEY'], company_id = nil)
    @api_key = api_key
    @company_id = company_id
  end

  def fetch_calls
    url = "/587877488/calls.json?company_id=#{@company_id}"
    options = { headers: { "Authorization" => "Token token=#{@api_key}" } }    
    
    Rails.logger.info "Requesting URL: 'https://api.callrail.com/v3/a' + url with options: #{options}"
    
    response = self.class.get(url, options)
    
    Rails.logger.info "Response code: #{response.code}"
    Rails.logger.info "Response body: #{response.body}"
    
    response
  end
end
