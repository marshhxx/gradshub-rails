class Api::V1::SessionsController < ApplicationController

  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    @user = user_email.present? && User.find_by(email: user_email)

    if not @user.nil? and @user.valid_password?(user_password)
      sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render :create, status: :ok, location: [:api, @user]
    else
      @reasons = ['Invalid email or password']
      render 'api/v1/common/error', status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(auth_token: params[:id])
    if @user.nil?
      @reasons = ['Invalid authentication token. User might not be logged in.']
      render 'api/v1/common/error', status: :unprocessable_entity
    else
      @user.generate_authentication_token!
      @user.save
      render json: { message: 'Successfully logged out' }, status: :accepted
    end
  end

  def password_reset
    @user = User.find_by_email(params[:email])
    if @user.present?
      @user.send_reset_password_instructions
      render json: { message: 'The password reset email has been sent.' }, status: :accepted
    else
      @reasons = ['There is no user with that email.']
      render 'api/v1/common/error', status: :unprocessable_entity
    end
  end
end