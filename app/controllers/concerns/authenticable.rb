module Authenticable

  def user_signed_in?
    session_from_header and current_user.present?
  end

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by_uid(session_from_header.user) if request.headers['Authorization']
  end

  def authenticate_with_token!
    unless user_signed_in?
      @error = {:reasons => ['Bad credentials.'], :code => AUTH_ERROR}
      render 'api/v1/common/error', status: :unauthorized and return
    end
    unless session_from_header.valid?
      @error = {:reasons => ['The session has expired.'], :code => SESSION_EXPIRED}
      render 'api/v1/common/error', status: :unauthorized and return
    end
  end

  def session_from_header
    @session_from_header ||= Session.from_jwt(request.headers['Authorization'].split(' ').last)
  end

end