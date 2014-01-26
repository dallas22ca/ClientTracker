json.array!(@contacts) do |contact|
  json.extract! contact, :id, :user_id, :key, :data
  json.url contact_url(contact, format: :json)
end
