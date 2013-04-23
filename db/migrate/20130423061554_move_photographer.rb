class MovePhotographer < ActiveRecord::Migration
  def up
    add_column :image_file_translations, :photographer, :string
    rename_column :image_files, :photographer, :photographer_old
  end

  def down
    remove_column :image_file_translations, :photographer
    rename_column :image_files, :photographer_old, :photographer
  end
end
