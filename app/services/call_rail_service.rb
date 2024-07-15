class CallRailService
  include HTTParty
  base_uri 'https://api.callrail.com/v3/a'

  def initialize(api_key, company_id = nil)
    @api_key = api_key
    @company_id = company_id
  end

  def fetch_calls
    url = @company_id ? "/#{@company_id}/calls.json" : "/calls.json"
    options = { headers: { "Authorization" => "Token token=#{@api_key}" } }
    self.class.get(url, options)
  end
end
