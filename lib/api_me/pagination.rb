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
      return Hash.new unless paging?

      {
        size: page_size.nil? ? default_page_size : page_size,
        offset: page_offset,
        record_count: scope.size,
        total_records: scope.total_count,
        total_pages: scope.total_pages
      }
    end

    protected

    def page
      self.scope = scope.page(self.page_offset ? page_offset : 1)
      self
    end

    def per
      if page_size
        self.scope = scope.per(page_size)
      end

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
