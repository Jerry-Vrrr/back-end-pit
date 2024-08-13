class CallRailData < ApplicationRecord
  validates :call_id, presence: true, uniqueness: true
  validates :company_id, presence: true

  # Add other validations as needed
end
