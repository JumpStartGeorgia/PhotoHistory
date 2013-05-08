class AddPublishedField < ActiveRecord::Migration
  def change
    add_column :pairings, :published, :boolean, :default => false
    add_column :pairings, :published_date, :datetime
    add_index :pairings, :published
  end
end
