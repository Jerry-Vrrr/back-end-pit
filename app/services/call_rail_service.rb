require 'httparty'

class CallRailService
  include HTTParty
  base_uri 'https://api.callrail.com/v3/a/587877488'

  def initialize(api_key, company_id)
    @api_key = api_key
    @company_id = company_id
  end

  def fetch_calls
    options = { headers: { "Authorization" => "Token token=\"#{@api_key}\"" } }
    self.class.get("/calls.json?company_id=#{@company_id}", options)
  end
end

