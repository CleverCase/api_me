class PostSerializer < ActiveModel::Serializer
  attributes :name

  has_one :user
end
