class AddLocationFilters < ActiveRecord::Migration
  def change
    add_column :image_files, :district, :string
    add_column :image_files, :special, :string
    add_index :image_files, :district
    add_index :image_files, :special
  end
end
