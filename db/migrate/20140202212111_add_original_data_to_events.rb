class AddOriginalDataToEvents < ActiveRecord::Migration
  def change
    add_column :events, :original_data, :hstore, default: {}
  end
end
