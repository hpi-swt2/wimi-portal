json.array!(@time_sheets) do |time_sheet|
  json.extract! time_sheet, :id, :month, :yeat, :salary, :salary_is_per_month, :workload, :workload_is_per_month, :user_id, :project_id
  json.url time_sheet_url(time_sheet, format: :json)
end
