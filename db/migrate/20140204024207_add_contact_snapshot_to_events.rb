class AddContactSnapshotToEvents < ActiveRecord::Migration
  def change
    add_column :events, :contact_snapshot, :hstore, default: {}
  end
end
