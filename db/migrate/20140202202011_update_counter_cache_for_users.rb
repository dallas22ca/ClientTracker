class UpdateCounterCacheForUsers < ActiveRecord::Migration
  def change
    User.find_each do |u|
      User.reset_counters u.id, :contacts_count
    end
  end
end
