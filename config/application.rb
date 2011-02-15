require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'exception_notifier'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module GemTesters
  class Application < Rails::Application
    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w()

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators do |g|
      g.test_framework      :rspec
      g.fixture_replacement :factory_girl
      g.template_engine     :haml
    end
    
    config.middleware.use ExceptionNotifier,
      :email_prefix => "[Gem-Testers Exception] ",
      :sender_address => %{"Support" <support@gem-testers.org>},
      :exception_recipients => %w{erik@hollensbe.org bluepojo@gmail.com} if Rails.env == 'production'
  end
end


require "#{Rails.root}/lib/response"
