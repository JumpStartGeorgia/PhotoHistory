class AddImageCity < ActiveRecord::Migration
  def change
    add_column :image_files, :city_id, :integer
    add_index :image_files, :city_id
  end
end
