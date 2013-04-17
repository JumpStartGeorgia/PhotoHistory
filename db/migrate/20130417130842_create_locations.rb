class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.integer :type_id

      t.timestamps
    end

    add_index :locations, :type_id

    Location.create_translation_table! :name => :string, :permalink => :string

    add_index :location_translations, :permalink
    add_index :location_translations, :name

    add_column :image_files, :district_id, :integer
    add_index :image_files, :district_id
    add_column :image_files, :special_id, :integer
    add_index :image_files, :special_id

  end

  def down
    remove_index :image_files, :district_id
    remove_column :image_files, :district_id
    remove_index :image_files, :special_id
    remove_column :image_files, :special_id

    drop_table :locations
    Location.drop_translation_table!
  end
end
