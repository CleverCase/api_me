module ApiMe
  class Sorting
    attr_accessor :sort_criteria, :sort_reverse, :scope

    def initialize(scope:, sort_params:)
      self.scope = scope
      if sort_params
        self.sort_criteria = sort_params[:criteria] || default_sort_criteria
        self.sort_reverse = sort_params[:reverse]
      end
    end

    def results
      sorting? ? sort(sort_criteria).scope : scope
    end

    def sort_meta
      return Hash.new unless sorting?
      {
        criteria: sort_criteria.is_blank? || sort_criteria === "" ? default_sort_criteria : sort_criteria,
        reverse: sort_reverse,
        record_count: scope.size,
        total_records: scope.total_count,
      }
    end

    protected

    def sort(criteria = default_sort_criteria)
      if sort_reverse === "true"
        self.scope = scope.order(criteria => :desc)
      else
        self.scope = scope.order(criteria => :asc)
      end
      self
    end

    private

    def default_sort_criteria
      sort_criteria = "id"
    end

    def sorting?
      sort_criteria || sort_reverse
    end

  end
end
