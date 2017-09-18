class TestModelSerializer < ActiveModel::Serializer
  attributes :created

  delegate :created, to: :object
end
