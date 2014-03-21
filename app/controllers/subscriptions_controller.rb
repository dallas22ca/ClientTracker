class SubscriptionsController < ApplicationController
  layout false

  def index
    begin
      decryptor = ActiveSupport::MessageEncryptor.new(CONFIG["secret"])
      token = decryptor.decrypt_and_verify Base64.decode64(params[:token])
      data = token.split(";")
      user = User.where(id: data.first).first
      @contact = user.contacts.where(id: data.last).first
      @contact.toggle! :subscribed if @contact
    rescue
    end
  end
end
