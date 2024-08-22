# config/initializers/current.rb

class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user_agent, :ip_address
end
