# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :name

  has_one :user
end
