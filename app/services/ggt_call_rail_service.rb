class GgtCallRailService
  include HTTParty
  base_uri 'https://api.callrail.com/v3/a'


  def fetch_calls
    url = "/377749628/calls.json?company_id=176449112"
    options = { headers: { "Authorization" => "Token token=9ef659a004baf7e1897723f4d3c3a115" } }
    
    Rails.logger.info "Requesting GGT URL: #{self.class.base_uri + url} with options: #{options}"
    response = self.class.get(url, options)
    Rails.logger.info "GGT Response code: #{response.code}"
    Rails.logger.info "GGT Response body: #{response.body}"

    response
  end
end
