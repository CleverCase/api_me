# frozen_string_literal: true

class Api::V1::MultiWordResourcesController < ApplicationController # rubocop:disable ClassAndModuleChildren, LineLength
  include ApiMe

  model TestModel
  serializer TestModelSerializer
end
