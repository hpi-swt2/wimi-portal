json.array!(@chair_applications) do |chair_application|
  json.extract! chair_application, :id, :user_id, :chair_id, :status
  json.url chair_application_url(chair_application, format: :json)
end
