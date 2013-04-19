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

ActiveRecord::Schema.define(:version => 20130419113331) do

  create_table "image_file_translations", :force => true do |t|
    t.integer  "image_file_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "image_file_translations", ["image_file_id"], :name => "index_image_file_translations_on_image_file_id"
  add_index "image_file_translations", ["locale"], :name => "index_image_file_translations_on_locale"

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
    t.string   "source"
    t.integer  "district_id"
    t.integer  "place_id"
  end

  add_index "image_files", ["district"], :name => "index_image_files_on_district"
  add_index "image_files", ["district_id"], :name => "index_image_files_on_district_id"
  add_index "image_files", ["place"], :name => "index_image_files_on_place"
  add_index "image_files", ["place_id"], :name => "index_image_files_on_place_id"
  add_index "image_files", ["source"], :name => "index_image_files_on_source"

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
  end

  add_index "pairings", ["image_file1_id"], :name => "index_pairings_on_image_file1_id"
  add_index "pairings", ["image_file2_id"], :name => "index_pairings_on_image_file2_id"

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

end
