class UpdateCounterCacheForUsers < ActiveRecord::Migration
  def change
    User.find_each do |u|
      u.update_columns contacts_count: u.contacts.count
    end
  end
end
