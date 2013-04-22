class RenameLocationsCategories < ActiveRecord::Migration
  def up
    remove_index "location_translations", :name => "index_location_translations_on_locale"
    remove_index "location_translations", :name => "index_location_translations_on_location_id"
    remove_index "location_translations", :name => "index_location_translations_on_name"
    remove_index "location_translations", :name => "index_location_translations_on_permalink"
    remove_index "locations", :name => "index_locations_on_type_id"
    
    rename_table :locations, :categories
    rename_column :location_translations, :location_id, :category_id
    rename_table :location_translations, :category_translations

    add_index "category_translations", ["locale"], :name => "index_category_translations_on_locale"
    add_index "category_translations", ["category_id"], :name => "index_category_translations_on_category_id"
    add_index "category_translations", ["name"], :name => "index_category_translations_on_name"
    add_index "category_translations", ["permalink"], :name => "index_category_translations_on_permalink"
    add_index "categories", ["type_id"], :name => "index_category_on_type_id"


  end

  def down
    remove_index "category_translations", :name => "index_category_translations_on_locale"
    remove_index "category_translations", :name => "index_category_translations_on_category_id"
    remove_index "category_translations", :name => "index_category_translations_on_name"
    remove_index "category_translations", :name => "index_category_translations_on_permalink"
    remove_index "categories", :name => "index_category_on_type_id"

    rename_table :categories, :locations
    rename_column :category_translations, :category_id, :location_id
    rename_table :category_translations, :location_translations

    add_index "location_translations", ["locale"], :name => "index_location_translations_on_locale"
    add_index "location_translations", ["location_id"], :name => "index_location_translations_on_location_id"
    add_index "location_translations", ["name"], :name => "index_location_translations_on_name"
    add_index "location_translations", ["permalink"], :name => "index_location_translations_on_permalink"
    add_index "locations", ["type_id"], :name => "index_locations_on_type_id"
  end
end
