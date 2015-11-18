json.array!(@chairs_administrators) do |chairs_administrator|
  json.extract! chairs_administrator, :id, :user_id, :chair_id
  json.url chairs_administrator_url(chairs_administrator, format: :json)
end
