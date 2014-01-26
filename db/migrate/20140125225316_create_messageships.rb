class CreateMessageships < ActiveRecord::Migration
  def change
    create_table :messageships do |t|
      t.belongs_to :message, index: true
      t.belongs_to :segment, index: true

      t.timestamps
    end
  end
end
