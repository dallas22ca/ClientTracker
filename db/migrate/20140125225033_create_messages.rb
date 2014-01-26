class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :user
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
