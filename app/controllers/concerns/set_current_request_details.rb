# app/controllers/concerns/set_current_request_details.rb
module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action :set_current_details
  end

  private

  def set_current_details
    Current.session = session[:session_id] if session
    Current.user_agent = request.user_agent
    Current.ip_address = request.remote_ip
  end
end
