class Message < ActiveRecord::Base
  has_many :messageships
  has_many :segments, through: :messageships
  has_many :sendable_contacts, through: :segments, source: :contacts
  
  after_commit :calculate_contacts_count
  after_commit :deliver
  
  def calculate_contacts_count
    self.update_columns contacts_count: sendable_contacts.count
  end
  
  def deliver
    for contact in sendable_contacts.where("contacts.data ? 'email'")
      MessageMailer.bulk(contact.id, self.id).deliver
    end
  end
end
