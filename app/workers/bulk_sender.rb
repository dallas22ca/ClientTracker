class BulkSender
  include Sidekiq::Worker
  sidekiq_options queue: "BulkSender"

  def perform(action, message_id, contact_id = false)
    case action
    when "prepare_for_delivery"
      Message.find(message_id).prepare_for_delivery
    when "deliver"
      MessageMailer.bulk(contact_id, message_id).deliver
    end
  end
end