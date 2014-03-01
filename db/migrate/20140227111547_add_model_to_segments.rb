class AddModelToSegments < ActiveRecord::Migration
  def change
    add_column :segments, :model, :string, default: "Contact"
  end
end
