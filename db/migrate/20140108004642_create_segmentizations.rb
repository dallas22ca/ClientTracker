class CreateSegmentizations < ActiveRecord::Migration
  def change
    create_table :segmentizations do |t|
      t.belongs_to :segment
      t.belongs_to :contact

      t.timestamps
    end
  end
end
