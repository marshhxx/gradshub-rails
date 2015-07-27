require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'devise'
require 'digest/sha1'
require 'oj'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
MultiJson.use(:oj)

module Demo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # Bower asset paths
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    root.join('vendor', 'assets', 'bower_components').to_s.tap do |bower_path|
      config.sass.load_paths << bower_path
      config.assets.paths << bower_path
    end
    # Precompile Bootstrap fonts
    config.assets.precompile << %r(bootstrap-sass-official/assets/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff)$)
    # Minimum Sass number precision required by bootstrap-sass
    ::Sass::Script::Number.precision = [10, ::Sass::Script::Number.precision].max

    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components', 'bootstrap-sass-official', 'assets', 'fonts')


    config.angular_templates.htmlcompressor = false
    config.skip_session_storage = [:http_auth, :token_auth]
  end
end
