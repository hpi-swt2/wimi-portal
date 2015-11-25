json.array!(@travel_expense_reports) do |travel_expense_report|
  json.extract! travel_expense_report, :id, :trip_id
  json.url travel_expense_report_url(travel_expense_report, format: :json)
end
