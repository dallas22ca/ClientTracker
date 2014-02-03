class UpdateCounterCacheForUsers < ActiveRecord::Migration
  def change
    User.find_each do |u|
      User.update(u.id, contacts_count: u.contacts.count)
    end
  end
end
