# Configuration values for your account are available
# in Cloudinary's Management Console (https://cloudinary.com/console)

Cloudinary.config do |config|
  config.cloud_name = ENV['cloudinary.username']
  config.api_key = ENV['cloudinary.api_key']
  config.api_secret = ENV['cloudinary.api_secret']
  config.cdn_subdomain = true
end