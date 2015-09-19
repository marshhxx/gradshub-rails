# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
GradshubRails::Application.initialize!

# Loggers
Rails.logger = Logger.new(STDOUT)
