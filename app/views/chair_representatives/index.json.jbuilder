json.array!(@chair_representatives) do |chair_representative|
  json.extract! chair_representative, :id, :user_id, :chair_id
  json.url chair_representative_url(chair_representative, format: :json)
end
