module Authenticable

  def user_signed_in?
    current_user.present?
  end

  def valid_session?
    Session.new(current_user).valid?
  end

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization']) if request.headers['Authorization']
  end

  def authenticate_with_token!
    authenticated = user_signed_in?
    valid = valid_session?
    @error = {:reasons => ['Bad credentials.'], :code => AUTH_ERROR} unless authenticated
    @error = {:reasons => ['The session has expired.'], :code => SESSION_EXPIRED} unless valid
    render 'api/v1/common/error', status: :unauthorized unless authenticated and valid
  end

  def refresh_session
    current_user.update(last_seen_at: DateTime.now)
  end

end