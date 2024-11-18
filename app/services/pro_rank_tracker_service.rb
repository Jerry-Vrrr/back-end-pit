class ProRankTrackerService
  include HTTParty
  base_uri 'https://api.proranktracker.com/v3'

  # Mapping of internal company IDs to ProRankTracker URL IDs
  PRT_COMPANY_MAPPING = {
    "apricot" => { company_id: 475663645, url_id: 479155 },
    "brock" => { company_id: 432770919, url_id: 1004010 },
    "brown_chiari" => { company_id: 754688700, url_id: 1654767 },
    "conger" => { company_id: 707808192, url_id: 1671297 },
    "cpj" => { company_id: 196651924, url_id: 1513362 },
    "crowell" => { company_id: 408997789, url_id: 1004020 },
    "greenstein" => { company_id: 788957891, url_id: 606353 },
    "dkb" => { company_id: 533921350, url_id: 1020875 },
    "lewis" => { company_id: 316384868, url_id: 1529689 },
    "lopez_humphries" => { company_id: 612344072, url_id: 1384993 },
    "mahoney" => { company_id: 595022144, url_id: 1339626 },
    "money" => { company_id: 258732157, url_id: 1541570 },
    "rozas" => { company_id: 427975086, url_id: 1681615 },
    "trust" => { company_id: 847306783, url_id: 1464853 },
    "ggt" => { company_id: 176449112, url_id: 1775302 }
  }.freeze

  def initialize(api_token = ENV['PRORANKTRACKER_API_KEY'])
    @api_token = api_token
  end

  # Fetch rankings for a specific company
  def fetch_rankings(company_name)
    mapping = PRT_COMPANY_MAPPING[company_name]

    unless mapping
      Rails.logger.error("Company name '#{company_name}' not found in PRT_COMPANY_MAPPING.")
      return nil
    end

    response = self.class.get(
      "/urls",
      headers: headers,
      query: { url_ids: [mapping[:url_id]] }
    )

    if response.success?
      {
        company_id: mapping[:company_id],
        rankings: response.parsed_response["data"]["url_terms"]
      }
    else
      Rails.logger.error("Failed to fetch data for company '#{company_name}' (url_id: #{mapping[:url_id]}): #{response.body}")
      nil
    end
  rescue => e
    Rails.logger.error("Error fetching data for company '#{company_name}': #{e.message}")
    nil
  end

  # Save keyword rankings to the database
  def save_rankings(data)
    return unless data
  
    company_id = data[:company_id]
    rankings = data[:rankings]
  
    rankings.each do |ranking|
      KeywordRanking.create!(
        company_id: company_id,
        keyword: ranking["name"],
        rank: ranking["rank"] == "NTH" ? 999 : ranking["rank"].to_i,
        base_rank: ranking["base_rank"],
        top_rank: ranking["top_rank"],
        local_monthly_searches: ranking["localmonthlysearches"],
        global_monthly_searches: ranking["globalmonthlysearches"],
        matched_url: ranking["matchedurl"],
        engine: ranking["engine"],
        fetched_at: Time.zone.now
      )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to save ranking for keyword '#{ranking['name']}': #{e.message}")
    end
  end
  

  private

  def headers
    { "X-TOKEN" => @api_token }
  end
end
