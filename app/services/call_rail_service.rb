class CallRailService
  include HTTParty
  base_uri 'https://api.callrail.com/v3/a'

  # Initialize with API key, primary company ID, and mapped company ID
  def initialize(api_key, primary_company_id, mapped_company_id)
    @api_key = api_key
    @primary_company_id = primary_company_id
    @company_id = mapped_company_id
  end

  # Fetch calls using given API key and company IDs
  def fetch_calls
    url = "/#{@primary_company_id}/calls.json?company_id=#{@company_id}"
    options = { headers: { "Authorization" => "Token token=#{@api_key}" } }

    Rails.logger.info "Requesting URL: #{self.class.base_uri + url} with options: #{options}"
    response = self.class.get(url, options)
    Rails.logger.info "Response code: #{response.code}"
    Rails.logger.info "Response body: #{response.body}"

    response
  end
end
