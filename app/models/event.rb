class Event < ActiveRecord::Base
  store_accessor :data
  belongs_to :contact
  belongs_to :user
  belongs_to :segment
  
  before_create :merge_contact_data
  
  validates_presence_of :contact
  validates_presence_of :user
  validates_presence_of :description
  
  def merge_contact_data
    contact.data ||= {}
    self.data ||= {}
    self.contact_snapshot = contact.data.merge(self.data.delete(:contact))
    contact.update_attributes data: self.contact_snapshot
  end
  
  def full_description
    Liquid::Template.parse(description).render({ "contact" => contact_snapshot }.merge(data))
  end
  
  def full_description_with_links
    linked_data = {}
    contact_data = contact_snapshot
    data.map { |k,v| linked_data[k] = ActionController::Base.helpers.link_to(v, Rails.application.routes.url_helpers.event_analysis_path(event_id: id, q: [[k, "=", v]]), remote: true) }
    contact_data.map { |k,v| contact_data[k] = ActionController::Base.helpers.link_to(v, Rails.application.routes.url_helpers.contact_path(contact)) }
    Liquid::Template.parse(description).render(linked_data.merge({ "contact" => contact_data }))
  end
end
