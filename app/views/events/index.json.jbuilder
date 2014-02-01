json.array!(@events) do |event|
  json.extract! event, :id, :contact_id, :description, :data
  json.url contact_event_url(event.contact, event, format: :json)
end
