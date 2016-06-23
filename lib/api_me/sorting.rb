module ApiMe
  class Sorting
    attr_accessor :sort_criteria, :sort_reverse, :scope

    def initialize(scope:, sort_params:)
      self.scope = scope
      if sort_params
        self.sort_criteria = sort_params[:criteria]
        self.sort_reverse = sort_params[:reverse]
      end
    end

    def results
      sorting? ? sort.scope : scope
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

    def sort
      unless sort_criteria === ""
        sort_p = sort_criteria
        if sort_reverse === "true"
          self.scope = scope.sort_by {|scope| scope[sort_p]}.reverse!
        else
          self.scope = scope.sort_by {|scope| scope[sort_p]}
        end
        self.scope
      else
        default_sort_criteria
        sort.scope
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
