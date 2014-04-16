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

ActiveRecord::Schema.define(:version => 20120811053136) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "slug"
    t.integer  "category_id"
    t.integer  "position"
    t.integer  "legacy_id"
    t.integer  "cover_id"
    t.string   "archive_file_name"
    t.string   "archive_content_type"
    t.integer  "archive_file_size"
    t.datetime "archive_updated_at"
    t.integer  "image_count"
  end

  add_index "albums", ["archive_file_name"], :name => "index_albums_on_archive_file_name"
  add_index "albums", ["category_id"], :name => "index_albums_on_category_id"
  add_index "albums", ["image_count"], :name => "index_albums_on_image_count"
  add_index "albums", ["legacy_id"], :name => "index_albums_on_legacy_id"
  add_index "albums", ["slug"], :name => "index_albums_on_slug"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "slug"
    t.integer  "legacy_id"
    t.integer  "image_count"
  end

  add_index "categories", ["image_count"], :name => "index_categories_on_image_count"
  add_index "categories", ["legacy_id"], :name => "index_categories_on_legacy_id"
  add_index "categories", ["lft"], :name => "index_categories_on_lft"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"
  add_index "categories", ["rgt"], :name => "index_categories_on_rgt"
  add_index "categories", ["slug"], :name => "index_categories_on_slug"

  create_table "images", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "slug"
    t.string   "subject_file_name"
    t.string   "subject_content_type"
    t.integer  "subject_file_size"
    t.datetime "subject_updated_at"
    t.integer  "album_id"
    t.integer  "views",                :default => 0
    t.integer  "legacy_pos"
    t.integer  "width"
    t.integer  "height"
    t.integer  "legacy_id"
  end

  add_index "images", ["album_id"], :name => "index_images_on_album_id"
  add_index "images", ["created_at"], :name => "index_images_on_created_at"
  add_index "images", ["legacy_id"], :name => "index_images_on_legacy_id"
  add_index "images", ["legacy_pos"], :name => "index_images_on_legacy_pos"
  add_index "images", ["slug"], :name => "index_images_on_slug"
  add_index "images", ["subject_file_name"], :name => "index_images_on_subject_file_name"
  add_index "images", ["views"], :name => "index_images_on_views"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
