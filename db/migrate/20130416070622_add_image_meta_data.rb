class AddImageMetaData < ActiveRecord::Migration
  def self.up
    add_column :image_files, :file_meta, :text
  end

  def self.down
    remove_column :image_files, :file_meta
  end
end
