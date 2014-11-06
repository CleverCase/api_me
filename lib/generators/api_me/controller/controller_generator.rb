module ApiMe
  module Generators
    class ControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision suffix: 'Controller'

      argument :attributes, type: :array, default: [], banner: 'field field'

      class_option :parent, type: :string, desc: 'The parent class for the generated controller'

      def create_api_controller_file
        template 'controller.rb', File.join('app/controllers',
                                            controllers_namespace,
                                            controllers_api_version,
                                            "#{plural_name}_controller.rb")
      end

      def controllers_namespace
        'api'
        # @generators.options.fetch(:api, {}).fetch(:namespace, 'api')
      end

      def controllers_api_version
        'v1'
        # @generators.options.fetch(:api, {}).fetch(:version, 'v1')
      end

      def controller_class_name
        "#{controllers_namespace.capitalize}::#{controllers_api_version.capitalize}::#{plural_name.camelize}Controller"
      end

      def attributes_names
        [:id] + attributes.select { |attr| !attr.reference? }.map { |a| a.name.to_sym }
      end

      def associations
        attributes.select(&:reference?)
      end

      def nonpolymorphic_attribute_names
        associations.select { |attr| attr.type.in?([:belongs_to, :references]) }
                    .reject { |attr| attr.attr_options.fetch(:polymorphic, false) }
                    .map { |attr| "#{attr.name}_id".to_sym }
      end

      def polymorphic_attribute_names
        associations.select { |attr| attr.type.in?([:belongs_to, :references]) }
                    .select { |attr| attr.attr_options.fetch(:polymorphic, false) }
                    .map { |attr| ["#{attr.name}_id".to_sym, "#{attr.name}_type".to_sym] }.flatten
      end

      def association_attribute_names
        nonpolymorphic_attribute_names + (polymorphic_attribute_names)
      end

      def strong_parameters
        (attributes_names + association_attribute_names).map(&:inspect).join(', ')
      end

      def parent_class_name
        base_controller_name = "#{controllers_namespace.capitalize}::BaseController"
        if options[:parent]
          options[:parent]
        else
          'ApplicationController'
        end
      end

      hook_for :test_framework
    end
  end
end
