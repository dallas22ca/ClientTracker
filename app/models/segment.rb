class Segment < ActiveRecord::Base
  serialize :conditions
  belongs_to :user
  
  has_many :segmentizations
  has_many :contacts, through: :segmentizations
  has_many :messageships
  has_many :messages, through: :messageships
  
  after_save :sync_segmentizations
  
  def sync_segmentizations
    new_segmentizations = []
    not_in = current_contacts.pluck(:id)
    
    no_longer = segmentizations.where("segmentizations.contact_id not in (?)", not_in)
    no_longer_count = no_longer.count
    no_longer.destroy_all
    
    current_segmentizations = segmentizations.pluck(:contact_id)
    current_segmentizations = [0] if current_segmentizations == []

    current_contacts.where("contacts.id not in (?)", current_segmentizations).find_each do |contact|
      s = { contact_id: contact.id, segment_id: id }
      new_segmentizations.push s
    end
    
    Segmentization.create new_segmentizations
    self.update_columns segmentizations_count: segmentizations.count
  end
  
  def user_contacts
    @user_contacts ||= user.contacts
  end
  
  def current_contacts
    n = 0
    query = ""
  
    conditions.each do |attribute, matcher, search, joiner|
      join = ""
      join = " #{joiner} " if conditions.size != n - 1
    
      if matcher == "exists"
        query += "contacts.data ? '#{attribute}'#{join}"
      elsif matcher == "!="
        query += "(exist(contacts.data, '#{attribute}') is false or contacts.data -> '#{attribute}' #{matcher} '#{search}') #{join}"
      else
        query += "contacts.data -> '#{attribute}' #{matcher} '#{search}'#{join}"
      end
    
      n += 1
    end
  
    @current_contacts ||= user_contacts.where(query)
  end
end
