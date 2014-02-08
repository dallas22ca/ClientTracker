class Segmentization < ActiveRecord::Base
  belongs_to :contact
  belongs_to :segment
  
  validates_uniqueness_of :contact_id, scope: :segment_id
end
