class GravityFormsService
  COMPANY_MAPPING = {
    "Apricot" => 475663645,
    "Brock" => 432770919,
    "Brown Chiari" => 754688700,
    "Conger" => 707808192,
    "CPJ" => 196651924,
    "Crowell" => 408997789,
    "Greenstein" => 788957891,
    "Greenberg" => 435195417,
    "KLAW" => 294642214,
    "Kohan Bablove" => 533921350,
    "Lewis" => 316384868,
    "Lopez Humphries" => 612344072,
    "Mahoney" => 595022144,
    "Money" => 258732157,
    "Rozas" => 427975086,
    "Trust" => 847306783
  }

  COMPANY_CREDENTIALS = {
    'greenstein' => {
      url: "#{ENV['GREENSTEIN_URL']}/wp-json/gf/v2/entries",
      username: ENV['GREENSTEIN_USERNAME'],
      password: ENV['GREENSTEIN_PASSWORD']
    },
    # Add other companies similarly
  }

  def initialize(company_name)
    @credentials = COMPANY_CREDENTIALS[company_name]
    @company_id = COMPANY_MAPPING[company_name.capitalize]
  end

  def fetch_entries
    return [] unless @credentials
  
    auth = { username: @credentials[:username], password: @credentials[:password] }
    fetch_url = @credentials[:url]
    Rails.logger.info("Fetching Gravity Forms data from URL: #{fetch_url}, Company ID: #{@company_id}")
  
    response = HTTParty.get(fetch_url, basic_auth: auth)
  
    if response.success?
      begin
        Rails.logger.info("Gravity Forms API Response: #{response.body}")
        parsed_response = JSON.parse(response.body)
        entries = parsed_response['entries']
        
        entries.map do |entry|
          Rails.logger.info("Processing entry: #{entry.inspect}")
          {
            id: entry['id'],
            form_id: entry['form_id'],
            date_created: entry['date_created'],
            name: "#{entry['2']} #{entry['21']}",
            phone: entry['16'],
            email: entry['17'],
            message: entry['20'],
            source_url: entry['source_url'],
            company_id: @company_id
          }
        end
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse JSON response: #{e.message}")
        []
      end
    else
      Rails.logger.error("Failed to fetch entries: #{response.body}")
      []
    end
  end
  
  
end
