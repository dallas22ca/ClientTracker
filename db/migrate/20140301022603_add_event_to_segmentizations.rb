class AddEventToSegmentizations < ActiveRecord::Migration
  def change
    add_reference :segmentizations, :event, index: true
  end
end
