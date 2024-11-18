class KeywordRanking < ApplicationRecord
  # Validations
  validates :company_id, :keyword, :fetched_at, presence: true
end
