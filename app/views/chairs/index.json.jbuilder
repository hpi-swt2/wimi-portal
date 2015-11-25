json.array!(@chairs) do |chair|
  json.extract! chair, :id, :name
  json.url chair_url(chair, format: :json)
end
