json.array!(@work_days) do |work_day|
  json.extract! work_day, :id, :date, :start_time, :brake, :end_time, :duration, :attendance, :notes
  json.url work_day_url(work_day, format: :json)
end
