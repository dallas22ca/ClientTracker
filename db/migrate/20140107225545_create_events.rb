class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :contact, index: true
      t.belongs_to :user, index: true
      t.text :description
      t.hstore :data, default: {}

      t.timestamps
    end
  end
end
