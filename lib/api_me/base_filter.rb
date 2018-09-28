# frozen_string_literal: true

module ApiMe
  class BaseFilter
    include SearchObject.module

    option(:ids) { |scope, value| scope.where('id' => value) }
  end
end
