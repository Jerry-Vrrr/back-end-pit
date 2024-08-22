# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :user, :user_agent, :ip_address

  def self.set_user(user)
    self.user = user
  end

  def self.set_user_agent(request)
    self.user_agent = request.user_agent
  end

  def self.set_ip_address(request)
    self.ip_address = request.remote_ip
  end
end
