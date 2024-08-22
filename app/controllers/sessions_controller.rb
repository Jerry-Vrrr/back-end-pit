class SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  before_action :set_session, only: %i[show destroy]

  def index
    render json: Current.user.sessions.order(created_at: :desc)
  end

  def show
    render json: @session
  end

  def create
    # Access the nested parameters under :user
    user_params = params.require(:user).permit(:email, :password)
  
    if user = User.authenticate_by(email: user_params[:email], password: user_params[:password])
      @session = user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip
      )
  
      # Log the session token before setting it in the header
      logger.info "Setting X-Session-Token to #{@session.signed_id}"
  
      response.set_header "X-Session-Token", @session.signed_id
  
      render json: @session, status: :created
    else
      render json: { error: "That email or password is incorrect" }, status: :unauthorized
    end
  end
  
  

  def destroy
    @session.destroy
  end

  private

    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
