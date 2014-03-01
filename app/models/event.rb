class Event < ActiveRecord::Base
  store_accessor :data
  belongs_to :contact
  belongs_to :user
  belongs_to :segment
  
  after_commit :sync_segmentizations
  after_destroy :sync_segmentizations
  
  validates_presence_of :contact
  validates_presence_of :user
  validates_presence_of :description
  
  def sync_segmentizations
    user.segments.map { |s| s.sidekiq_sync_segmentizations } if user
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
