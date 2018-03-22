module ApiMe
  module Generators
    class FilterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      check_class_collision suffix: 'Filter'

      argument :attributes, type: :array, default: [], banner: 'field field'

      class_option :parent, type: :string, desc: 'The parent class for the generated filter'

      def create_api_filter_file
        template 'filter.rb', File.join('app/filters', "#{singular_name}_filter.rb")
      end

      def filter_class_name
        "#{class_name}Filter"
      end

      def attributes_names
        attributes.reject(&:reference?).map { |a| a.name.to_sym }
      end

      def associations
        attributes.select(&:reference?)
      end

      def nonpolymorphic_attribute_names
        associations.select { |attr| attr.type.in?(%i[belongs_to references]) }
                    .reject { |attr| attr.attr_options.fetch(:polymorphic, false) }
                    .map { |attr| "#{attr.name}_id".to_sym }
      end

      def polymorphic_attribute_names
        associations.select { |attr| attr.type.in?(%i[belongs_to references]) }
                    .select { |attr| attr.attr_options.fetch(:polymorphic, false) }
                    .map { |attr| ["#{attr.name}_id".to_sym, "#{attr.name}_type".to_sym] }.flatten
      end

      def association_attribute_names
        nonpolymorphic_attribute_names + polymorphic_attribute_names
      end

      def strong_parameters
        (attributes_names + association_attribute_names).map(&:inspect).join(', ')
      end

      def parent_class_name
        if options[:parent]
          options[:parent]
        else
          'ApiMe::BaseFilter'
        end
      end

      hook_for :test_framework
    end
  end
end
