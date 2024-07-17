class CallRailService
  include HTTParty
  base_uri 'https://api.callrail.com/v3/a/587877488'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_calls
    options = { headers: { "Authorization" => "Token token=#{@api_key}" } }
    self.class.get('/calls.json?company_id=788957891', options)
  end
end

