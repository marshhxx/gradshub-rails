module Authenticable

  def user_signed_in?
    current_user.present?
  end

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    @error = {:resons => ["Not authenticated"], :code => AUTH_ERROR}
    render 'api/v1/common/error', status: :unauthorized unless user_signed_in?
  end

end