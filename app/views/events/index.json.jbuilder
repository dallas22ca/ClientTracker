json.array!(@events) do |event|
  json.extract! event, :id, :contact_id, :description, :data
  json.url event_url(event, format: :json)
end
