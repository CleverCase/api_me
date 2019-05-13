# frozen_string_literal: true

require 'active_model_serializers/model'

class TestModel < ActiveModelSerializers::Model
  attributes :created

  def self.create
    @created = true
  end

  def self.created
    @created ||= false
  end

  def initialize(*_args); end

  def save!(*_args)
    TestModel.create
  end

  def created
    TestModel.created
  end
end
