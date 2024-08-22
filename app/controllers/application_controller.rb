class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include SetCurrentRequestDetails

  before_action :set_current_request_details
  before_action :authenticate

  private
  def authenticate
    authenticate_with_http_token do |token, _options|
      session_record = Session.find_signed(token.gsub("Bearer ", ""))
      if session_record
        Current.session = session_record
      else
        request_http_token_authentication
      end
    end
  end
  

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
