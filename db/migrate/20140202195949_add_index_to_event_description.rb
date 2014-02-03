class AddIndexToEventDescription < ActiveRecord::Migration
  def change
    add_index :events, :description
  end
end
