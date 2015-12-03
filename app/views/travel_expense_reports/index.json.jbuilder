json.array!(@travel_expense_reports) do |travel_expense_report|
  json.extract! travel_expense_report, :id, :first_name, :last_name, :inland, :country, :location_from, :location_via, :location_to, :reason, :date_start, :date_end, :car, :public_transport, :vehicle_advance, :hotel, :general_advance, :user_id
  json.url travel_expense_report_url(travel_expense_report, format: :json)
end
