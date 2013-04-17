class AddSourceField < ActiveRecord::Migration
  def change
    add_column :image_files, :source, :string
    add_index :image_files, :source
  end
end
