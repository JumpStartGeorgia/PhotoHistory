class RenameSpecialPlace < ActiveRecord::Migration
  def up
    remove_index "image_files", :name => "index_image_files_on_special"
    remove_index "image_files", :name => "index_image_files_on_special_id"

    rename_column :image_files, :special, :place
    rename_column :image_files, :special_id, :place_id

    add_index "image_files", ["place"], :name => "index_image_files_on_place"
    add_index "image_files", ["place_id"], :name => "index_image_files_on_place_id"
    
  end

  def down
    remove_index "image_files", ["place"], :name => "index_image_files_on_place"
    remove_index "image_files", ["place_id"], :name => "index_image_files_on_place_id"

    rename_column :image_files, :place, :special 
    rename_column :image_files, :place_id, :special_id

    add_index "image_files", ["special"], :name => "index_image_files_on_special"
    add_index "image_files", ["special_id"], :name => "index_image_files_on_special_id"
  end
end
