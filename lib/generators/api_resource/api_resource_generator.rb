class ApiResourceGenerator < Rails::Generators::Base
  def run_generators
    params = @_initializer[0]
    invoke "model", params
    invoke "serializer", params + ["created_at", "updated_at"]
    invoke "api_policy", params
    invoke "api_controller", params
  end
end
