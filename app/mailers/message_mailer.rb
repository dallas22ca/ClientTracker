class MessageMailer < ActionMailer::Base
  default from: "dallas@livehours.co"

  def bulk(contact_id, message_id)
    contact = Contact.find(contact_id)
    message = Message.find(message_id)
    template = Liquid::Template.parse(message.body)
    @body = template.render(contact.data)
    mail to: contact.data["email"], subject: message.subject
  end
end
