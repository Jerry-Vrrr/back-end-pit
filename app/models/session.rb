class Session < ApplicationRecord
  belongs_to :user

  validates :user_agent, :ip_address, presence: true

  before_create do
    self.user_agent = Current.user_agent
    self.ip_address = Current.ip_address
  end
end
