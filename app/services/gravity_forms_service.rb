class GravityFormsService
  COMPANY_MAPPING = {
    "apricot" => 475663645,
    "brock" => 432770919,
    "brown_chiari" => 754688700,
    "conger" => 707808192,
    "cpj" => 196651924,
    "crowell" => 408997789,
    "greenstein" => 788957891,
    "greenberg" => 435195417,
    "klaw" => 294642214,
    "kohan_bablove" => 533921350,
    "lewis" => 316384868,
    "lopez_humphries" => 612344072,
    "mahoney" => 595022144,
    "money" => 258732157,
    "rozas" => 427975086,
    "trust" => 847306783
  }

  COMPANY_CREDENTIALS = {
    'lopez_humphries' => {
      url: "#{ENV['LOPEZ_HUMPHRIES_URL']}/wp-json/gf/v2/entries",
      username: ENV['LOPEZ_HUMPHRIES_USERNAME'],
      password: ENV['LOPEZ_HUMPHRIES_PASSWORD']
    },
    'lewis' => {
      url: "#{ENV['LEWIS_URL']}/wp-json/gf/v2/entries",
      username: ENV['LEWIS_USERNAME'],
      password: ENV['LEWIS_PASSWORD']
    },
    'apricot' => {
      url: "#{ENV['APRICOT_URL']}/wp-json/gf/v2/entries",
      username: ENV['APRICOT_USERNAME'],
      password: ENV['APRICOT_PASSWORD']
    },
    'brock' => {
      url: "#{ENV['BROCK_URL']}/wp-json/gf/v2/entries",
      username: ENV['BROCK_USERNAME'],
      password: ENV['BROCK_PASSWORD']
    },
    'cpj' => {
      url: "#{ENV['CPJ_URL']}/wp-json/gf/v2/entries",
      username: ENV['CPJ_USERNAME'],
      password: ENV['CPJ_PASSWORD']
    },
    'brown_chiari' => {
      url: "#{ENV['BROWN_CHIARI_URL']}/wp-json/gf/v2/entries",
      username: ENV['BROWN_CHIARI_USERNAME'],
      password: ENV['BROWN_CHIARI_PASSWORD']
    },
    'greenstein' => {
      url: "#{ENV['GREENSTEIN_URL']}/wp-json/gf/v2/entries",
      username: ENV['GREENSTEIN_USERNAME'],
      password: ENV['GREENSTEIN_PASSWORD']
    },
    'conger' => {
      url: "#{ENV['CONGER_URL']}/wp-json/gf/v2/entries",
      username: ENV['CONGER_USERNAME'],
      password: ENV['CONGER_PASSWORD']
    },
    'dkb' => {
      url: "#{ENV['DKB_URL']}/wp-json/gf/v2/entries",
      username: ENV['DKB_USERNAME'],
      password: ENV['DKB_PASSWORD']
    },
    'mahoney' => {
      url: "#{ENV['MAHONEY_URL']}/wp-json/gf/v2/entries",
      username: ENV['MAHONEY_USERNAME'],
      password: ENV['MAHONEY_PASSWORD']
    },
    'money' => {
      url: "#{ENV['MONEY_URL']}/wp-json/gf/v2/entries",
      username: ENV['MONEY_USERNAME'],
      password: ENV['MONEY_PASSWORD']
    },
    'rozas' => {
      url: "#{ENV['ROZAS_URL']}/wp-json/gf/v2/entries",
      username: ENV['ROZAS_USERNAME'],
      password: ENV['ROZAS_PASSWORD']
    }
  }

  FIELD_MAPPINGS = {
    'lopez_humphries' => {
      name: ->(entry) { "#{entry['2']} #{entry['21']}" },
      phone: '16',
      email: '21',
      message: '20'
    },
    'lewis' => {
      name: '1',
      phone: '6',
      email: '2',
      message: '5'
    },
    'apricot' => {
      name: ->(entry) { "#{entry['1']} #{entry['9']}" },
      phone: '7',
      email: '2',
      message: '5'
    },
    'conger' => {
      name: ->(entry) { "#{entry['1']} #{entry['2']}" },
      phone: '3',
      email: '4',
      message: '7'
    },
    'brock' => {
      name: '1',
      phone: '2',
      email: '3',
      message: '4'
    },
    'brown_chiari' => {
      name: '1',
      phone: '4',
      email: '7',
      message: '6'
    },
    'dkb' => {
      name: '1',
      phone: '3',
      email: '2',
      message: '5'
    },
    'mahoney' => {
      name: ->(entry) { "#{entry['1']} #{entry['2']}" },
      phone: '4',
      email: '3',
      message: '5'
    },
    'money' => {
      name: '1',
      phone: '4',
      email: '3',
      message: '5'
    },
    'cpj' => {
      name: '4',
      phone: '7',
      email: '3',
      message: '6'
    },
    'rozas' => {
      name: ->(entry) { "#{entry['1']} #{entry['2']}" },
      phone: '3',
      email: '4',
      message: '7'
    },
    'default' => {
      name: ->(entry) { "#{entry['2']} #{entry['21']}" },
      phone: '16',
      email: '17',
      message: '20'
    }
  }

  def initialize(company_name)
    @company_name = company_name
    @company_key = company_name.downcase.tr(" ", "_") # Convert to lowercase and replace spaces with underscores
    @credentials = COMPANY_CREDENTIALS[@company_key]
    @company_id = COMPANY_MAPPING[@company_key]
    Rails.logger.info("Initializing GravityFormsService for Company ID: #{@company_id}, Company Key: #{@company_key}")
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
  
        mapping = FIELD_MAPPINGS[@company_key] || FIELD_MAPPINGS['default']
  
        entries.map do |entry|
          message = entry[mapping[:message]]
          next if message.nil? || message.strip.empty?
  
          Rails.logger.info("Processing entry: #{entry.inspect}")
          {
            id: entry['id'],
            form_id: entry['form_id'],
            date_created: entry['date_created'],
            name: mapping[:name].is_a?(Proc) ? mapping[:name].call(entry) : entry[mapping[:name]],
            phone: entry[mapping[:phone]],
            email: entry[mapping[:email]],
            message: message,
            source_url: entry['source_url'],
            company_id: @company_id
          }
        end.compact
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse JSON response for company #{@company_name}: #{e.message}")
        []
      rescue TypeError => e
        Rails.logger.error("TypeError encountered for company #{@company_name}: #{e.message}")
        []
      end
    else
      Rails.logger.error("Failed to fetch entries for company #{@company_name}: #{response.body}")
      []
    end
  end  
end
