class GravityFormsService
  COMPANY_MAPPING = {
    "apricot" => 475663645, #login - Jerry@apricot - 
    "brock" => 432770919, #login - brocklawsocial@gmail.com	
    "brown_chiari" => 754688700, #login - BrownChiariLLPlawny@gmail.com' password: ''
    "conger" => 707808192, #login - 'CongerLawInjuryAttysCA@gmail.com' password: ''
    "cpj" => 196651924, #login -  ConwayPauleyJohnsonLawNE@gmail.com
    "crowell" => 408997789, #login - crowelllawofficesca@gmail.com
    "greenstein" => 788957891, #login - greensteinmilbauersocial@gmail.com	
    "greenberg" => 435195417, #login - greenberglawsocial@gmail.com'
    "klaw" => 294642214, #login - KLGlawyerny@gmail.com
    "dkb" => 533921350, #login - dkblawyerssocial@gmail.com
    "lewis" => 316384868, #login - CLAssociatesLaw@gmail.com
    "lopez_humphries" => 612344072, #login - lhpamaster@gmail.com
    "mahoney" => 595022144, #login - MahoneyMahoneyLaw@gmail.com
    "money" => 258732157, #login - moneyfirstlendingNV@gmail.com
    "rozas" => 427975086, #login - RozasLawFirmLLCLA@gmail.com
    "trust" => 847306783 #login - davidsmithlegal@gmail.com
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
    },
    'greenberg' => {
  url: "#{ENV['GREENBERG_URL']}/wp-json/gf/v2/entries",
  username: ENV['GREENBERG_USERNAME'],
  password: ENV['GREENBERG_PASSWORD']
}
  }

  FIELD_MAPPINGS = {
    'lopez_humphries' => {
      name: '1',
      phone: '4',
      email: '3',
      message: '6'
    },
    'lewis' => {
      name: '1',
      phone: '6',
      email: '2',
      message: '5'
    },
    'apricot' => {
      name: '1',
      phone: '7',
      email: '2',
      message: '4'
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
      phone: '6',
      email: '5',
      message: '10'
    },
    'greenberg' => {
      name: ->(entry) { "#{entry['3']} #{entry['6']}" },
      phone: '5',
      email: '4',
      message: '1'
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
    @company_key = company_name.downcase.tr(" ", "_")
    @credentials = COMPANY_CREDENTIALS[@company_key]
    @company_id = COMPANY_MAPPING[@company_key]
    Rails.logger.info("Initializing GravityFormsService for Company ID: #{@company_id}, Company Key: #{@company_key}")
  end

  def fetch_entries
    unless @credentials
      Rails.logger.error("No credentials found for #{@company_name}. Skipping data fetch.")
      return []
    end

    auth = { username: @credentials[:username], password: @credentials[:password] }
    fetch_url = @credentials[:url]

    # Log before initiating the HTTP request
    Rails.logger.info("Attempting to fetch entries for #{@company_name} using URL: #{fetch_url} with credentials: #{auth.inspect}")

    begin
      response = HTTParty.get(fetch_url, basic_auth: auth)
      log_response(response)
    rescue StandardError => e
      Rails.logger.error("HTTP request failed for #{@company_name}: #{e.message}")
      return []
    end

    if response.success?
      process_entries(response.body)
    else
      Rails.logger.error("Failed to fetch entries for #{@company_name} with status #{response.code}: #{response.body}")
      []
    end
  end

  private

  def log_response(response)
    Rails.logger.info("Response status for #{@company_name}: #{response.code}")
    if response.body.nil? || response.body.empty?
      Rails.logger.warn("Empty response body for #{@company_name}")
    else
      Rails.logger.info("Received response body for #{@company_name}: #{response.body[0..500]}") # Log the first 500 characters of the response
    end
  end

  def process_entries(response_body)
    begin
      parsed_response = JSON.parse(response_body)
      entries = parsed_response['entries']

      mapping = FIELD_MAPPINGS[@company_key] || FIELD_MAPPINGS['default']
      Rails.logger.info("Field mappings for #{@company_name}: #{mapping.inspect}")

      entries.map do |entry|
        process_entry(entry, mapping)
      end.compact
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse JSON response for company #{@company_name}: #{e.message}")
      []
    rescue TypeError => e
      Rails.logger.error("TypeError encountered for company #{@company_name}: #{e.message}")
      []
    end
  end

  def process_entry(entry, mapping)
    message = entry[mapping[:message]]
    if message.nil? || message.strip.empty?
      Rails.logger.info("Skipping entry for #{@company_name} due to empty message: #{entry.inspect}")
      return nil
    end

    existing_entry = GravityFormEntry.find_by(message: message, company_id: @company_id)
    if existing_entry
      Rails.logger.info("Skipping duplicate entry for #{@company_name}: #{entry.inspect}")
      return nil
    end

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
  end
end





#securepassword123