class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :user, index: true
      t.string :key
      t.hstore :data, default: {}

      t.timestamps
    end
  end
end
