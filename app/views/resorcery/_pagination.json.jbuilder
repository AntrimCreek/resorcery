# Kaminari pagination
json.pagination do
  json.extract! resources, :current_page, :total_pages, :limit_value, :total_count
end
