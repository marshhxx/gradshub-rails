class Api::V1::SessionsController < ApplicationController

  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    @user = user_email.present? && User.find_by(email: user_email)

    if not @user.nil? and @user.valid_password?(user_password)
      sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render :create, status: :ok
    else
      @error = {:reasons => ['Invalid email or password'], :code => AUTH_ERROR}
      render_api_error
    end
  end

  def destroy
    @user = User.find_by(auth_token: params[:id])
    if @user.nil?
      @error = {:reasons => ['Invalid authentication token. User might not be logged in.'],
                  :code => AUTH_ERROR}
      render_api_error
    else
      @user.generate_authentication_token!
      @user.save
      render json: { message: 'Successfully logged out' }, status: :accepted
    end
  end

  def password_reset_request
    @user = User.find_by_email(params[:email])
    if @user.present?
      @user.send_reset_password_instructions
      render json: { message: 'The password reset email has been sent.' }, status: :accepted
    else
      @error = {:reasons => ['There is no user with that email.'], :code => AUTH_ERROR}
      render_api_error
    end
  end

  def password_reset
    reset_user = User.reset_password_by_token(params[:user])
    if reset_user.errors.empty?
      logger.info('Password updated')
      render json: { message: 'Password successfully updated.'}, status: :accepted
    else
      @error = {:reasons => [reset_user.errors.full_messages], :code => INVALID_PARAMS_ERROR}
      render_api_error
    end
  end
end