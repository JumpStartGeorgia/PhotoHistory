class AddPhotographer < ActiveRecord::Migration
  def change
    add_column :image_files, :photographer, :string
  end
end
