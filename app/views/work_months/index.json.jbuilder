json.array!(@work_months) do |work_month|
  json.extract! work_month, :id, :name, :year
  json.url work_month_url(work_month, format: :json)
end
