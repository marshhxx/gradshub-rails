require 'jwt'

class JsonWebToken
  SECRET = Rails.application.secrets.json_web_token_secret

  def self.encode(payload, expiration)
    payload = payload.dup
    payload[:exp] = expiration.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    JWT.decode(token, SECRET)
  end

end