require 'search_object'

class UserFilter < ApiMe::BaseFilter
  include ::SearchObject.module

  option(:search) { |scope, value| scope.where("username LIKE ?", "%#{value}%") }
end
