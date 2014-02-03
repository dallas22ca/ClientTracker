class Event < ActiveRecord::Base
  store_accessor :data
  belongs_to :contact
  belongs_to :user
  
  before_save :merge_contact_data
  after_save :update_contact
  
  validates_presence_of :contact
  validates_presence_of :user
  validates_presence_of :description
  
  def merge_contact_data
    self.data = contact.data.merge data
  end
  
  def update_contact
    contact.update_attributes data: data
  end
  
  def full_description
    Liquid::Template.parse(description).render(data)
  end
  
  def full_description_with_links
    linked_data = {}
    data.map { |k,v| linked_data[k] = ActionController::Base.helpers.link_to(v, Rails.application.routes.url_helpers.contact_event_path(contact, self)) }
    Liquid::Template.parse(description).render(linked_data)
  end
end
