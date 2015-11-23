json.array!(@chair_admins) do |chair_admin|
  json.extract! chair_admin, :id, :user_id, :chair_id
  json.url chair_admin_url(chair_admin, format: :json)
end
