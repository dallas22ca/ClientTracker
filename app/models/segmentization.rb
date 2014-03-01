class Segmentization < ActiveRecord::Base
  belongs_to :contact
  belongs_to :segment
  belongs_to :event
  
  validates_uniqueness_of :contact_id, scope: :segment_id, if: Proc.new { event_id.blank? }
end
