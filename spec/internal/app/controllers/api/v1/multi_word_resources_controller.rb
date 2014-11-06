class Api::V1::MultiWordResourcesController < ApplicationController
  include ApiMe

  model TestModel
  serializer TestModelSerializer
end
