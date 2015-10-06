json.array!(@holidays) do |holiday|
  json.extract! holiday, :id
  json.url holiday_url(holiday, format: :json)
end
