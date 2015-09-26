class Session
  attr_accessor :user, :expiration

  def initialize(user, expiration = Rails.application.config.session_ttl.from_now)
    self.user = user
    self.expiration = expiration
  end

  def self.from_jwt(jwt_token)
    jwt = JsonWebToken.decode(jwt_token)[0]
    Session.new(jwt['user'], jwt['exp'])
  end

  def expired?
    self.expiration.blank? or self.expiration < Time.now.to_i
  end

  def valid?
    !expired?
  end

  def generate_token
    ::JsonWebToken.encode({user: self.user}, self.expiration)
  end

  def update
    Session.new(self.user)
  end

end