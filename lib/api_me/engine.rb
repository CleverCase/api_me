# frozen_string_literal: true

begin
  require 'active_model_serializers'
rescue LoadError
  puts "Could not load 'active_model_serializers'"
  exit
end

module ApiMe
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
