# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150326121014) do

  create_table "categories", :force => true do |t|
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["type_id"], :name => "index_category_on_type_id"

  create_table "category_translations", :force => true do |t|
    t.integer  "category_id"
    t.string   "locale"
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_translations", ["category_id"], :name => "index_category_translations_on_category_id"
  add_index "category_translations", ["locale"], :name => "index_category_translations_on_locale"
  add_index "category_translations", ["name"], :name => "index_category_translations_on_name"
  add_index "category_translations", ["permalink"], :name => "index_category_translations_on_permalink"

  create_table "image_file_events", :force => true do |t|
    t.integer  "image_file_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "image_file_events", ["event_id"], :name => "index_image_file_events_on_event_id"
  add_index "image_file_events", ["image_file_id"], :name => "index_image_file_events_on_image_file_id"

  create_table "image_file_translations", :force => true do |t|
    t.integer  "image_file_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photographer"
    t.string   "source"
  end

  add_index "image_file_translations", ["image_file_id"], :name => "index_image_file_translations_on_image_file_id"
  add_index "image_file_translations", ["locale"], :name => "index_image_file_translations_on_locale"
  add_index "image_file_translations", ["source"], :name => "index_image_file_translations_on_source"

  create_table "image_files", :force => true do |t|
    t.integer  "year"
    t.decimal  "lat",               :precision => 15, :scale => 10
    t.decimal  "lon",               :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "district"
    t.string   "place"
    t.text     "file_meta"
    t.string   "old_source"
    t.integer  "district_id"
    t.integer  "place_id"
    t.boolean  "add_watermark",                                     :default => false
    t.string   "photographer_old"
    t.integer  "city_id"
  end

  add_index "image_files", ["city_id"], :name => "index_image_files_on_city_id"
  add_index "image_files", ["district"], :name => "index_image_files_on_district"
  add_index "image_files", ["district_id"], :name => "index_image_files_on_district_id"
  add_index "image_files", ["old_source"], :name => "index_image_files_on_source"
  add_index "image_files", ["place"], :name => "index_image_files_on_place"
  add_index "image_files", ["place_id"], :name => "index_image_files_on_place_id"

  create_table "impressions", :force => true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], :name => "controlleraction_ip_index"
  add_index "impressions", ["controller_name", "action_name", "request_hash"], :name => "controlleraction_request_index"
  add_index "impressions", ["controller_name", "action_name", "session_hash"], :name => "controlleraction_session_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], :name => "poly_ip_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], :name => "poly_request_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], :name => "poly_session_index"
  add_index "impressions", ["user_id"], :name => "index_impressions_on_user_id"

  create_table "location_translations", :force => true do |t|
    t.integer  "location_id"
    t.string   "locale"
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "location_translations", ["locale"], :name => "index_location_translations_on_locale"
  add_index "location_translations", ["location_id"], :name => "index_location_translations_on_location_id"
  add_index "location_translations", ["name"], :name => "index_location_translations_on_name"
  add_index "location_translations", ["permalink"], :name => "index_location_translations_on_permalink"

  create_table "locations", :force => true do |t|
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["type_id"], :name => "index_locations_on_type_id"

  create_table "pairing_translations", :force => true do |t|
    t.integer  "pairing_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "long_description", :limit => 16777215
  end

  add_index "pairing_translations", ["locale"], :name => "index_pairing_translations_on_locale"
  add_index "pairing_translations", ["pairing_id"], :name => "index_pairing_translations_on_pairing_id"

  create_table "pairings", :force => true do |t|
    t.integer  "image_file1_id"
    t.integer  "image_file2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "stacked_img_file_name"
    t.string   "stacked_img_content_type"
    t.integer  "stacked_img_file_size"
    t.datetime "stacked_img_updated_at"
    t.integer  "impressions_count",        :default => 0
    t.boolean  "published",                :default => false
    t.datetime "published_date"
  end

  add_index "pairings", ["image_file1_id"], :name => "index_pairings_on_image_file1_id"
  add_index "pairings", ["image_file2_id"], :name => "index_pairings_on_image_file2_id"
  add_index "pairings", ["impressions_count"], :name => "index_pairings_on_impressions_count"
  add_index "pairings", ["published"], :name => "index_pairings_on_published"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.integer  "role",                   :default => 0,  :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "year_range_translations", :force => true do |t|
    t.integer  "year_range_id"
    t.string   "locale"
    t.string   "title"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "year_range_translations", ["locale"], :name => "index_year_range_translations_on_locale"
  add_index "year_range_translations", ["permalink"], :name => "index_year_range_translations_on_permalink"
  add_index "year_range_translations", ["title"], :name => "index_year_range_translations_on_title"
  add_index "year_range_translations", ["year_range_id"], :name => "index_year_range_translations_on_year_range_id"

  create_table "year_ranges", :force => true do |t|
    t.integer  "start"
    t.integer  "end"
    t.integer  "sort",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "year_ranges", ["sort"], :name => "index_year_ranges_on_sort"

end
