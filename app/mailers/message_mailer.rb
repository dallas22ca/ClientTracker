class MessageMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper

  default from: "no-reply@secure.remetric.com"

  def bulk(contact_id, message_id)
    encryptor = ActiveSupport::MessageEncryptor.new(CONFIG["secret"])
    contact = Contact.find(contact_id)
    message = Message.find(message_id)
    user = message.user
    details = { "contact" => contact.data }
    
    token = Base64.encode64 encryptor.encrypt_and_sign("#{user.id};#{contact_id}")
    @subscribe = subscribe_url(token)
    
    body = Liquid::Template.parse(message.body)
    @body = body.render(details)
    subject = Liquid::Template.parse(message.subject)
    @subject = subject.render(details)
    
    mail to: contact.data["email"], subject: @subject, from: "#{user.name} <#{user.email}>"
  end
end
