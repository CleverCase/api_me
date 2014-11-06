class TestModelSerializer < ActiveModel::Serializer
  attributes :created
  
  def created
    object.created
  end
end
