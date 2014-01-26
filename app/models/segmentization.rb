class Segmentization < ActiveRecord::Base
  belongs_to :contact
  belongs_to :segment
  
  validates_uniqueness_of :contact, scope: :segment
end
