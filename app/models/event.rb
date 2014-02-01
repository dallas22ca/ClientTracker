class Event < ActiveRecord::Base
  store_accessor :data
  belongs_to :contact
  belongs_to :user
  
  after_save :update_contact
  
  def update_contact
    contact.update_attributes data: contact.data.merge(data)
  end
  
  def full_description
    Liquid::Template.parse(description).render(data)
  end
end
