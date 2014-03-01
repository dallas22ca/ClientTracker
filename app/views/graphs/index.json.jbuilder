json.array!(@graphs) do |graph|
  json.extract! graph, :id, :title, :style, :data
  json.url graph_url(graph, format: :json)
end
