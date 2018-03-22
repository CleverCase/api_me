begin
  require 'active_model_serializers'
rescue LoadError
  puts "Could not load 'active_model_serializers'"
  exit
end

module ApiMe
  class Engine < ::Rails::Engine
  end
end
