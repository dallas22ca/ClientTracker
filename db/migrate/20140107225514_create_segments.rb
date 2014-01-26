class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.text :conditions, default: []

      t.timestamps
    end
  end
end
