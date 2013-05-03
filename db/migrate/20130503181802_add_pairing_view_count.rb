class AddPairingViewCount < ActiveRecord::Migration
  def change
    add_column :pairings, :impressions_count, :integer, :default => 0
    add_index :pairings, :impressions_count
  end
end
