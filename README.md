[![Gem Version](https://badge.fury.io/rb/api_me.png)](http://badge.fury.io/rb/api_me) [![Build Status](https://travis-ci.org/wildland/api_me.svg?branch=master)](https://travis-ci.org/inigo-llc/api_me) [![Code Climate](https://codeclimate.com/github/inigo-llc/api_me/badges/gpa.svg)](https://codeclimate.com/github/inigo-llc/api_me) [![Dependency Status](https://gemnasium.com/inigo-llc/api_me.svg)](https://gemnasium.com/inigo-llc/api_me)
ApiMe
=========

## This gem is currently a work in progress, follows semver, and may change significantly until version 1.0

### A gem for building RESTful Api resources in Rails
ApiMe provides a set of generators and base classes to assist with building Restful API's in Ruby on Rails.

### Details
Api controllers use the fantastic [Pundit](https://github.com/elabs/pundit) gem for authorization and parameter whitelisting, [Active Model Serializers ver 0.8](https://github.com/rails-api/active_model_serializers/tree/0-8-stable) for resource serialization, and [SearchObject](https://github.com/RStankov/SearchObject) for list filtering. The model, filter, serializer, and policy that the controller uses by default can all be overriden, along with other optional parameters.

The primary goal of this gem was to keep things simple so that customization is fairly straight forward by separating concerns and providing overrides. Reusing existing libraries was a primary goal during the design, hence the overall simplicity of this gem. We currently use this gem internally at [Inigo](inigo.io) and are committed to its ongoing maintenance.

### Upgrade from 0.7.X to 0.8.X
- Upgrade to the latest version of 0.7.X. Run the app/tests and check/fix all deprecations
- Upgrade to the latest version of 0.8.X, update active_model_serializers to 0.10.X.
- Add the following initializer:
  `config/initializers/active_model_serializer.rb`
  ```rb
  ActiveModelSerializers.config.adapter = :json
  ```
- Remove all `embed ...` methods from the serializers
- Update all belongs-to relationships to have FKs, serialize the FK id in all active model serializers instead of embeding the relationship (I.E. `has_one :foo` becomes `attributes :foo_id`)
- Update all has-many relationships to serialize the ids instead of embeding the relationship. (I.E. `has_many :foos` becomes `attributes :foo_ids`)
- Remove all has-one relationships and manually build a method to serialize the id. Ex:
  ```rb
  attributes :foo_id

  def foo_id
    object.foo ? object.foo.id : nil
  end
  ```
- Embeded has-one and belongs-to relationships look the same on the serializer, so look at the model to identify the differences.

### Installation
Add the gem to your Gemfile: `gem api_me`.

Run `bundle install` to install it.

Run `rails generate api_me:install` to install api_me.

You are now setup!

### Usage
`rails generate api_me:resource user organization:belongs_to name:string ...`

this generates the following:

* app/controllers/api/v1/users_controller.rb
* app/policies/user_policy.rb
* app/serializers/user_serializer.rb

and also essentially calls:
* `rails generate model user organization:belongs_to name:string ...`
Which generates the model et al as specified.

users_controller.rb:
````rb
class UsersController < ApplicationController
  include ApiMe

end
````
POST (create) and PUT (update) requests are expected to post parameters to the singular underscored name of the model by default (I.E. `{"user": {"name": "Test"}}` for a user model), but this can be overriden by overriding `def params_klass_symbol`, or more in-depth by overriding `def object_params`. If `def object_params` is overriden, parameters are also expected be whitelisted inside of this method.

models/user.rb:
````rb
# Standard Rails generator used
class User < ActiveRecord::Base
  belongs_to :organization
end
````

policies/user_policy.rb (See [Pundit](https://github.com/elabs/pundit) for details):
````rb
class UserPolicy < ApplicationPolicy
  # Authorizes what parameters will be whitelisted, see [Pundit](https://github.com/elabs/pundit) for details
  def permitted_attributes
    [:id, :organization_id, :name]
  end

end
````

serializers/user_serializer.rb (See [Active Model Serializers ver 0.8](https://github.com/rails-api/active_model_serializers/tree/0-8-stable) for details):
````rb
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :organization_id
end
````

filters/user_filter.rb (See [SearchObject](https://github.com/RStankov/SearchObject) for details):
````rb
require 'search_object'

class UserFilter < ApiMe::BaseFilter
  include ::SearchObject.module #required

  # Add custom filter logic here
  # Ex:
  #   option(:search) { |scope, value| scope.where("username LIKE ?", "%#{value}%") }
end
````
The ApiMe::BaseFilter is called if no filter exists for the resource, by default the base filter provides filtering by ids for convenience. I.E a GET to `/api/v1/users?ids%5B%5D=1&ids%5B%5D=3` would return users filtered by ids of 1 and 3. All other filters are expected by default to be located at `params[:filters]` and not at the base level.

### Sorting

To enable sorting just pass `sort` in your request with `sortCiteria` and `sortReverse`.

Ember Example
````js
return this.store.query('some-model', {
  filters: {
    cool_models_only: true
  },
  sort:  {
    criteria: 'createdAt', // Property to sort on.
    reverse: false, // True reverses the sort.
  }
});
````

### Pagination

To enable pagination just pass `page` in your request with `size` and `offset`.

Also see [ember-bootstrap-controls](http://localhost:4200/?s=Bootstrap%20Controls&ss=Pagination) for a handy control for easy pagination with ember.

Ember Example
````js
return this.store.query('some-model', {
  filters: {
    cool_models_only: true
  },
  sort:  {
    criteria: 'createdAt', // Property to sort on.
    reverse: false, // True reverses the sort.
  },
  page:  {
    size: 50, // Size of a page. Number of results per page.
    offset: false, /* The page number you want to see.
                      Imagine 103 records are available.
                      If the size of 50 is given as a parameter
                      then valid inputs to offset would be 1, 2, and 3. */
  }
});
````


Your response will contain a meta object with the following data:
```js
meta: {
  size: n           // Size input above
  offset: m         // Offset input above
  record_count: i   /* The number of records in the page.
                       In the `offset` example above pages 1 and 2
                       would have a record_count of 50 while page 3
                       would have a record count of 3. */
  total_records: j // Total number of records accessible
  total_pages: k   // Total number of pages accessible
}
```

### Overrides
Overriding the default model class, serializer class, filter class, and filter parameter can be done like so:

users_controller.rb:
````rb
class UsersController < ApplicationController
  include ApiMe

  model FakeUser
  serialzier RealUserSerialzier

  def filter_klass
    FancyUserFilter
  end

  def filter_params
    params[:meta][:filters]
  end
end
````

#### Todo:
- [ ]  Add the ability to specify the api controller path (I.E. app/controllers/api/v2)
- [ ]  Add the ability to inject the resource route into the routes file in the resource generators

## Code Of Conduct
Wildland Open Source [Code Of Conduct](https://github.com/wildland/code-of-conduct)

## License
Copyright (c) 2014, Api Me is developed and maintained by Sam Clopton, and is released under the open MIT Licence.
