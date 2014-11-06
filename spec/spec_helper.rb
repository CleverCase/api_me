require 'rubygems'
require 'bundler/setup'
require 'combustion'

Bundler.require :default, :development

Combustion.initialize! :active_record, :action_controller

require 'rspec/rails'
require 'rack/test'

module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.include ApiHelper

end
