class AddSubscribedToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :subscribed, :boolean, default: true
  end
end
