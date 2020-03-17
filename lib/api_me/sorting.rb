# frozen_string_literal: true

module ApiMe
  class Sorting
    attr_reader :custom_sort_options
    attr_accessor :sort_criteria, :sort_reverse, :scope

    def initialize(scope:, sort_params:, custom_sort_options: {})
      self.scope = scope

      return unless sort_params

      self.sort_criteria = sort_params[:criteria] || default_sort_criteria
      self.sort_reverse = sort_params[:reverse] || false
    end

    def results
      sorting? ? sort(sort_criteria).scope : scope
    end

    def sort_meta
      return {} unless sorting?
      {
        criteria: sort_meta_criteria,
        reverse: sort_reverse
      }
    end

    protected

    def sort_meta_criteria
      if sort_criteria.blank?
        default_sort_criteria
      else
        sort_criteria
      end
    end

    def sort(criteria = default_sort_criteria)
      self.scope = sorted_scope(criteria)
      self
    end

    def sorted_scope(criteria)
      criteria_key = criteria.to_sym
      if custom_sort_options.key?(criteria_key)
        if sort_reverse == 'true'
          custom_sort_scope(criteria_key).order("#{custom_sort_options[criteria_key][:column]} DESC")
        else
          custom_sort_scope(criteria_key).order("#{custom_sort_options[criteria_key][:column]} ASC")
        end
      elsif sort_reverse == 'true'
        scope.order(criteria => :desc)
      else
        scope.order(criteria => :asc)
      end
    end

    private

    def custom_sort_scope(criteria)
      custom_sort_options[criteria].key?(:joins) ? scope.joins(custom_sort_options[criteria][:joins]) : scope
    end

    def default_sort_criteria
      'id'
    end

    def sorting?
      sort_criteria || sort_reverse
    end
  end
end
