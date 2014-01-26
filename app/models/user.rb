class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :contacts
  has_many :events
  has_many :segments
  
  before_create :generate_api_key
  
  def generate_api_key
    self.api_key = loop do
      api_key = SecureRandom.urlsafe_base64(36).gsub(/-|_/, "")
      break api_key unless User.exists?(api_key: api_key)
    end
  end
  
  def contacts_in_segments(segment_ids = [])
    if segment_ids
      contact_ids = Segmentization.where(segment_id: segment_ids).pluck(:contact_id)
      contacts.where(id: contact_ids)
    else
      contacts
    end
  end
end
