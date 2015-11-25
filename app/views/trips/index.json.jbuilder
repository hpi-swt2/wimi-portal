json.array!(@trips) do |trip|
  json.extract! trip, :id, :name, :destination, :reason, :start_date, :end_date, :days_abroad, :annotation, :signature
  json.url trip_url(trip, format: :json)
end
