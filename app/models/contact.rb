class Contact < ActiveRecord::Base
  store_accessor :data
  
  belongs_to :user, touch: true, counter_cache: true
  
  has_many :segmentizations, dependent: :destroy
  has_many :segments, through: :segmentizations
  has_many :events, dependent: :destroy
  
  validates_presence_of :key
  validates_uniqueness_of :key, scope: :user_id
  
  before_save :parameterize_data
  after_commit :sync_segmentizations
  after_destroy :sync_segmentizations
  
  scope :has_email, -> { where("contacts.data ? 'email'") }
  scope :subscribed, -> { where(subscribed: true) }
  
  def parameterize_data
    self.data ||= {}; d = {}; 
    self.data.map { |k, v| d[k.to_s.parameterize] = v }
    self.data = d
    self.key = key.parameterize
  end
  
  def sync_segmentizations
    user.segments.map { |s| s.sidekiq_sync_segmentizations } if user
  end
  
  def to_param
    key
  end
end
