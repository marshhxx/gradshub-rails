module Authenticable

  def user_signed_in?
    current_user.present?
  end

  # Devise methods overwrites
  def current_user
    a = request.headers['Authorization']
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    @reasons = "Not authenticated"
    render 'api/v1/common/error',
           status: :unauthorized unless user_signed_in?
  end

end