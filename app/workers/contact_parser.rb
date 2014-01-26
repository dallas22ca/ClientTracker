class ContactParser
  include Sidekiq::Worker
  sidekiq_options queue: "ContactParser"

  def perform(id)
    user = User.find id
    user.parse_contacts
  end
end