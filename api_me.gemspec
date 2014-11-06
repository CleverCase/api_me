# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_me/version'

Gem::Specification.new do |s|
	s.name        = 'api_me'
	s.version     = ApiMe::VERSION
	s.authors     = ['Sam Clopton']
	s.email       = ['samsinite@gmail.com']
	s.homepage    = 'https://github.com/inigo/api_me'
	s.summary     = 'Api Me'
	s.description = "This friendly library gives you helpers and generators to assist building RESTful API's in your Rails app."
	s.license     = 'MIT'

	s.files         = `git ls-files`.split("\n")
	s.test_files    = `git ls-files -- {spec}/*`.split("\n")
	s.require_paths = ['lib', 'app']

	s.add_runtime_dependency     'activerecord',  					 '>= 3.2.0'
	s.add_runtime_dependency     'activesupport', 					 '>= 3.2.0'
	s.add_runtime_dependency     'pundit',     							 '~> 0.1'
	s.add_runtime_dependency     'active_model_serializers', '~> 0.8.0'

	s.add_development_dependency 'combustion',  '~> 0.5.1'
	s.add_development_dependency 'rspec-rails', '~> 2.13'
	s.add_development_dependency 'sqlite3',     '~> 1.3.7'
end
