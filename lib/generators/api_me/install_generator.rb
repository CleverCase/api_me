# frozen_string_literal: true

module ApiMe
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def run_generators
        # Install Pundit
        run 'rails g pundit:install'

        # Add Pundit rpsec helpers
        prepend_to_file 'spec/spec_helper.rb', "require 'pundit/rspec'\n"
      end
    end
  end
end
