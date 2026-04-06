module PaginationHelper
  DEFAULT_PAGE     = 1
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE     = 100

  def paginate(scope, params)
    page     = [params[:page].to_i,     1].max
    per_page = [[params[:per_page].to_i, DEFAULT_PER_PAGE].max, MAX_PER_PAGE].min
    per_page = DEFAULT_PER_PAGE if per_page.zero?

    total   = scope.count
    records = scope.offset((page - 1) * per_page).limit(per_page)

    {
      data: records,
      meta: {
        current_page: page,
        per_page:     per_page,
        total_count:  total,
        total_pages:  (total.to_f / per_page).ceil
      }
    }
  end
end