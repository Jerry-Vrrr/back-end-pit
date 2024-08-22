class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def create
    @user = User.new(user_params)

    if @user.save
      session = @user.sessions.create! # Create a session for the new user
      response.set_header "X-Session-Token", session.signed_id # Set the session token in the response header
      render json: { message: "User successfully created", user: @user }, status: :created
    else
      # Return detailed error messages if the user couldn't be created
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
