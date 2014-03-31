class Segmentization < ActiveRecord::Base
  belongs_to :contact
  belongs_to :segment
  belongs_to :event
  
  validates_uniqueness_of :segment_id, scope: [:contact_id, :event_id]
end
