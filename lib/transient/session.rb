class Session
  TTL = Rails.application.config.session_ttl

  def initialize(user)
    @token = user.auth_token
    @last_seen = user.last_seen_at
  end

  def ttl
    return TTL unless @last_seen
    elapsed = Time.now - @last_seen
    remaining = (TTL - elapsed).floor
    remaining > 0 ? remaining : 0
  end

  def expired?
    ttl < 1
  end

  def valid?
    !expired?
  end

end