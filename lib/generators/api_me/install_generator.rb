module ApiMe
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def run_generators
        run 'rails g pundit:install'
      end
    end
  end
end
