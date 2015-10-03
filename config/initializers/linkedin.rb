LinkedIn.configure do |config|
  config.token = ENV['linkedin.token']
  config.secret = ENV['linkedin.secret']
  config.default_profile_fields = ['id', 'positions', 'first-name', 'last-name', 'maiden-name', 'formatted-name',
                                   'headline', 'location', 'industry', 'current-share', 'summary', 'specialties',
                                   'picture-url', 'email-address']
end