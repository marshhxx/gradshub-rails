class Api::V1::SessionsController < ApplicationController

  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    @user = user_email.present? && User.find_by(email: user_email)

    if not @user.nil? and @user.valid_password? user_password
      sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render :create, status: :ok, location: [:api, @user]
    else
      @reasons = ['Invalid username or password']
      render 'api/v1/common/error', status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(auth_token: params[:id])
    if @user.nil?
      render 'api/v1/common/error', status: :unprocessable_entity
    else
      @user.generate_authentication_token!
      @user.save
      render json: { message: 'Successfully logged out' }, status: :accepted
    end
  end
end