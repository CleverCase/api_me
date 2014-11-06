module ApiMe
  module Generators
    class ResourceGenerator < Rails::Generators::Base
      def run_generators
        params = @_initializer[0]
        invoke "model", params
        invoke "serializer", params + ["created_at", "updated_at"]
        invoke "api_me:policy", params
        invoke "api_me:controller", params
      end
    end
  end
end
