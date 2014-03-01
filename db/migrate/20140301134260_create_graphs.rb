class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.belongs_to :user
      t.string :title
      t.string :style
      t.hstore :data

      t.timestamps
    end
  end
end
