class AddPairingThumbnail < ActiveRecord::Migration
  def up

    add_column :pairings, :thumbnail_file_name, :string
    add_column :pairings, :thumbnail_content_type, :string
    add_column :pairings, :thumbnail_file_size, :integer
    add_column :pairings, :thumbnail_updated_at, :datetime
  end

  def down
    remove_column :pairings, :thumbnail_file_name, :string
    remove_column :pairings, :thumbnail_content_type, :string
    remove_column :pairings, :thumbnail_file_size, :integer
    remove_column :pairings, :thumbnail_updated_at, :datetime
  end
end
