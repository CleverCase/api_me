# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_me/version'

Gem::Specification.new do |s|
  s.name        = 'api_me'
  s.version     = ApiMe::VERSION
  s.authors     = ['Sam Clopton', 'Joe Weakley']
  s.email       = ['samsinite@gmail.com']
  s.homepage    = 'https://github.com/wildland/api_me'
  s.summary     = 'Api Me'
  s.description = "This friendly library gives you helpers and generators to assist building RESTful API's in your Rails app."
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails',                    '>= 4.2'
  s.add_dependency 'actionview',               '>= 4.2.11.1'
  s.add_dependency 'activejob',                '>= 4.2.11'
  s.add_dependency 'pundit',                   '~> 2.0'
  s.add_dependency 'active_model_serializers', '~> 0.10.6'
  s.add_dependency 'search_object',            '~> 1.0'
  s.add_dependency 'kaminari',                 '~> 1.0'

  s.add_development_dependency 'rspec-rails', '>= 3.6.1'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rubocop', '>= 0.27.0'
end
