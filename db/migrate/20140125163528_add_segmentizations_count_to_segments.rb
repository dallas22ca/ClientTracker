class AddSegmentizationsCountToSegments < ActiveRecord::Migration
  def change
    add_column :segments, :segmentizations_count, :integer, default: 0
  end
end
