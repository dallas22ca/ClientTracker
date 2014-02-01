class remetric
  require "rest-client"

  def initialize api_key, sandbox = false
    @api_key = api_key
    @sandbox = sandbox
  end
  
  def create_contact contact
    c = {}
    key = contact.delete "key"
    key = contact.delete :key unless key
    c["key"] = key
    c["data"] = contact
    post "/contacts.json", { "contact" => c }
  end
  
  def update_contact contact = {}
    post "/contacts/#{contact["key"]}.json", { "contact" => contact }
  end
  
  def contacts
    get "/contacts.json"
  end
  
  def get path
    uri = URI.parse "#{end_point}#{path}?api_token=#{@api_token}"
    Net::HTTP::get(uri).body
  end
  
  def post path, params
    params = params.merge({ api_key: @api_key })
    RestClient.post "#{end_point}#{path}", params
  end
  
  def end_point
    @sandbox ? "http://localhost:3000" : "http://newsite.com"
  end
end
