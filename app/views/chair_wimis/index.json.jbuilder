json.array!(@chair_wimis) do |chair_wimi|
  json.extract! chair_wimi, :id, :user_id, :chair_id
  json.url chair_wimi_url(chair_wimi, format: :json)
end
