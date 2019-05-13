# frozen_string_literal: true

class Api::V1::MultiWordResourcesController < ApplicationController # rubocop:disable ClassAndModuleChildren, LineLength
  include ApiMe

  def model_klass
    @model_klass ||= TestModel
  end

  def serializer_klass
    @serializer_klass ||= TestModelSerializer
  end
end
