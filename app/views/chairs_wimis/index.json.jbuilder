json.array!(@chairs_wimis) do |chairs_wimi|
  json.extract! chairs_wimi, :id, :user_id, :chair_id
  json.url chairs_wimi_url(chairs_wimi, format: :json)
end
