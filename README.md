[![Gem Version](https://badge.fury.io/rb/api_me.png)](http://badge.fury.io/rb/api_me) [![Build Status](https://travis-ci.org/inigo-llc/api_me.png?branch=master)](https://travis-ci.org/inigo-llc/api_me) [![Code Climate](https://codeclimate.com/github/inigo-llc/api_me/badges/gpa.svg)](https://codeclimate.com/github/inigo-llc/api_me) [![Dependency Status](https://gemnasium.com/inigo-llc/api_me.svg)](https://gemnasium.com/inigo-llc/api_me)
ApiMe
=========

## This gem is currently a work in progress, follows semver, and may change significantly until version 1.0

### A gem for building RESTful Api resources in Rails
ApiMe provides a set of generators and base classes to assist with building Restful API's in Ruby on Rails.

### Usage
`rails g api_me:resource user organization:belongs_to name:string ...`

this generates the following:

* app/controllers/api/v1/users_controller.rb
* app/policies/user_policy.rb
* app/serializers/user_serializer.rb
* app/models/user.rb

Or

users_controller.rb
````rb
class UsersController < ApplicationController
  include ApiMe
end
````

#### This gem uses the following libraries:
* Pundit
* Active Model Serializers (0.8)

#### Todo:
- [ ]  Add the ability to specify resource filters
- [ ]  Add the ability to specify the api controller path (I.E. app/controllers/api/v2)

## License
Copyright (c) 2014, Api Me is developed and maintained by Sam Clopton, and is released under the open MIT Licence.
