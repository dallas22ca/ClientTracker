class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :contacts
  has_many :events
  has_many :segments
  has_many :messages
  
  has_attached_file :file,
                    :path  => Rails.env.development? || Rails.env.test? ? "#{Rails.root}/uploads/:user_id/:hash.:extension" : "/home/deployer/apps/clienttracker/shared/uploads/:user_id/:hash.:extension",
                    :url => "/uploads/:user_id/:hash.:extension",
                    :hash_secret => "R3sadkfasd8fkj8k0a8dfyh3jr23uy32r3j2j23hlk3j"
  
  Paperclip.interpolates :user_id do |file, style|
    file.instance.id
  end
  
  before_create :generate_api_key
  after_commit :sidekiq_parse_contacts, if: Proc.new { file.exists? }
  
  def sidekiq_parse_contacts
    ContactParser.perform_in 1.minute, id
  end
  
  def parse_contacts
    i = Importer.new id
    i.import
  end
  
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
  
  def allowed_to_email?
    email == "dallas@livehours.co" || email == "ghostlitinfo@gmail.com"
  end
  
  def admin?
    email == "dallas@livehours.co"
  end
end
