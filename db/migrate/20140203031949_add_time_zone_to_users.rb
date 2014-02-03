class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, default: "Atlantic Time (Canada)"
  end
end
