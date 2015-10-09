ApiPagination.configure do |config|
  # If you have both gems included, you can choose a paginator.
  config.paginator = :kaminari
  # By default, this is set to 'Total'
  config.total_header = 'X-Total'
  # By default, this is set to 'Per-Page'
  config.per_page_header = 'X-Per-Page'
end