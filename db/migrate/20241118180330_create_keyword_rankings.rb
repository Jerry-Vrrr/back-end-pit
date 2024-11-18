class CreateKeywordRankings < ActiveRecord::Migration[6.1]
  def change
    create_table :keyword_rankings do |t|
      t.integer :company_id, null: false  # Directly stores IDs from COMPANY_MAPPING
      t.string :keyword, null: false     # Keyword being tracked
      t.integer :rank                    # Current rank
      t.integer :base_rank               # Initial rank
      t.integer :top_rank                # Best rank achieved
      t.integer :local_monthly_searches  # Local search volume
      t.integer :global_monthly_searches # Global search volume
      t.string :matched_url              # Indexed URL for the keyword
      t.string :engine, null: false, default: "Google.com" # Search engine
      t.datetime :fetched_at, null: false # Timestamp for when data was fetched

      t.timestamps
    end
  end
end
