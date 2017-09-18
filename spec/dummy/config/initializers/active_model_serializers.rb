# frozen_string_literal: true

require 'active_model_serializers'

ActiveModelSerializers.config.adapter = :json

ActionController::Renderers.add :json do |obj, options|
  self.content_type ||= Mime::JSON
  serializable_resource = ActiveModelSerializers::SerializableResource.new(obj, options)
  if serializable_resource.respond_to?(:to_json)
    serializable_resource.to_json
  else
    serializable_resource
  end
end
