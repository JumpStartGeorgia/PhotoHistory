class CreateImages < ActiveRecord::Migration
  def up
    create_table :image_files do |t|
      
      t.integer :year
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lon, :precision => 15, :scale => 10

      t.timestamps
    end

    add_column :image_files, :file_file_name, :string
    add_column :image_files, :file_content_type, :string
    add_column :image_files, :file_file_size, :integer
    add_column :image_files, :file_updated_at, :datetime

    ImageFile.create_translation_table! :name => :string, :description => :text
  end

  def down
    drop_table :image_files
    ImageFile.drop_translation_table!
  end
end
