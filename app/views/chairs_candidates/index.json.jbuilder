json.array!(@chairs_candidates) do |chairs_candidate|
  json.extract! chairs_candidate, :id, :user_id, :chair_id
  json.url chairs_candidate_url(chairs_candidate, format: :json)
end
