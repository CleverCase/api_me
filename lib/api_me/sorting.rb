# frozen_string_literal: true

module ApiMe
  class Sorting
    attr_accessor :sort_criteria, :sort_reverse, :scope

    def initialize(scope:, sort_params:)
      self.scope = scope
      return unless sort_params
      self.sort_criteria = sort_params[:criteria] || default_sort_criteria
      self.sort_reverse = sort_params[:reverse]
    end

    def results
      sorting? ? sort(sort_criteria).scope : scope
    end

    def sort_meta
      return {} unless sorting?
      {
        criteria: sort_meta_criteria,
        reverse: sort_reverse,
        record_count: scope.size,
        total_records: scope.total_count
      }
    end

    protected

    def sort_meta_criteria
      if sort_criteria.is_blank?
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
      if sort_reverse === 'true'
        scope.order(criteria => :desc)
      else
        scope.order(criteria => :asc)
      end
    end

    private

    def default_sort_criteria
      'id'
    end

    def sorting?
      sort_criteria || sort_reverse
    end
  end
end
