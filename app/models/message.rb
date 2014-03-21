class Message < ActiveRecord::Base
  belongs_to :user
  
  has_many :messageships
  has_many :segments, through: :messageships
  has_many :sendable_contacts, through: :segments, source: :contacts
  
  validate :has_segments?

  after_commit :calculate_contacts_count
  after_commit :sidekiq_prepare_for_delivery, unless: :sent
  
  def has_segments?
    errors.add :base, "Please choose at least one segment!" if self.segments.blank?
  end
  
  def sidekiq_prepare_for_delivery
    BulkSender.perform_async "prepare_for_delivery", id
  end
  
  def calculate_contacts_count
    self.update_columns contacts_count: sendable_contacts.count
  end
  
  def prepare_for_delivery
    unless sent?
      mark_as_sent

      for contact_id in sendable_contacts.subscribed.has_email.pluck(:contact_id).uniq
        BulkSender.perform_async "deliver", id, contact_id
      end
    end
  end
  
  def mark_as_sent
    update_attributes sent: true
  end
end
