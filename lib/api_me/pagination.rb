module ApiMe
  class Pagination
    attr_accessor :page_size, :page_offset, :scope

    def initialize(scope:, page_params:)
      self.scope = scope

      if page_params
        self.page_size = page_params[:size]
        self.page_offset = page_params[:offset]
      end
    end

    def results
      paging? ? page.per.scope : scope
    end

    def page_meta
      return {} unless paging?
      iteration_count_start = (page_size.to_i * (page_offset.to_i - 1)) + 1
      iteration_count_end = page_size.to_i * page_offset.to_i
      iteration_count_offset = scope.total_count < iteration_count_end ? scope.total_count : iteration_count_end
      {
        size: page_size.nil? ? default_page_size : page_size,
        offset: page_offset,
        record_count: scope.size,
        total_records: scope.total_count,
        total_pages: scope.total_pages,
        iteration_count_start: iteration_count_start,
        iteration_count_end: iteration_count_end,
        current_iteration_count: iteration_count_start - iteration_count_offset
      }
    end

    protected

    def page
      self.scope = scope.page(page_offset ? page_offset : 1)
      self
    end

    def per
      self.scope = scope.per(page_size) if page_size
      self
    end

    private

    def default_page_size
      Kaminari.config.default_per_page
    end

    def paging?
      page_size || page_offset
    end
  end
end
