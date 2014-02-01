class MessageMailer < ActionMailer::Base
  default from: "no-reply@secure.remetric.com"

  def bulk(contact_id, message_id)
    contact = Contact.find(contact_id)
    message = Message.find(message_id)
    user = message.user
    template = Liquid::Template.parse(message.body)
    @body = template.render(contact.data)
    
    mail to: contact.data["email"], subject: message.subject, from: "#{user.name} <#{user.email}>"
  end
end
