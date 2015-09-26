module Authenticable

  def user_signed_in?
    session_from_header and current_user.present?
  end

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by_uid(session_from_header.user)
  end

  def authenticate_with_token!
    authenticated = user_signed_in?
    valid = session_from_header.valid?
    @error = {:reasons => ['Bad credentials.'], :code => AUTH_ERROR} unless authenticated
    @error = {:reasons => ['The session has expired.'], :code => SESSION_EXPIRED} unless valid
    render 'api/v1/common/error', status: :unauthorized unless authenticated and valid
  end

  def session_from_header
    @session_from_header ||= Session.from_jwt(request.headers['Authorization'].split(' ').last)
  end

end