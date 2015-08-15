# Represents the authentication entity that saves the identity of the user, the provider of
# the oauth integration (such as linkedin). This entity is transient.
class Auth
  attr_accessor :uid, :provider
  def initialize(uid, access_token, provider)
    @uid=uid
    @provider=provider
    @access_token=access_token
  end

  def info
    @info ||= call_api
  end

  private

  # Calls the linkedin API to get the user information.
  def call_api
    client = ::LinkedIn::Client.new
    consumer = client.consumer
    # here we get the oauth1 token from the oauth2 access_token
    @token = consumer.get_access_token(nil, {}, {
                                              'xoauth_oauth2_access_token' => @access_token
                                          })
    client.authorize_from_access(@token.token, @token.secret)
    @info = client.profile
  end
end