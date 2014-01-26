class AddContactsCountToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :contacts_count, :integer, default: 0
  end
end
