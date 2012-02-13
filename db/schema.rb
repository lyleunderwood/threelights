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

ActiveRecord::Schema.define(:version => 20120213005543) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "category_id"
    t.integer  "position"
    t.integer  "legacy_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "slug"
    t.integer  "legacy_id"
  end

  create_table "cpg1410_albums", :primary_key => "aid", :force => true do |t|
    t.string  "title",                           :default => "",    :null => false
    t.text    "description",                                        :null => false
    t.integer "visibility",                      :default => 0,     :null => false
    t.string  "uploads",           :limit => 0,  :default => "NO",  :null => false
    t.string  "comments",          :limit => 0,  :default => "YES", :null => false
    t.string  "votes",             :limit => 0,  :default => "YES", :null => false
    t.integer "pos",                             :default => 0,     :null => false
    t.integer "category",                        :default => 0,     :null => false
    t.integer "thumb",                           :default => 0,     :null => false
    t.string  "keyword",           :limit => 50
    t.string  "alb_password",      :limit => 32
    t.text    "alb_password_hint"
  end

  add_index "cpg1410_albums", ["category"], :name => "alb_category"

  create_table "cpg1410_banned", :primary_key => "ban_id", :force => true do |t|
    t.integer  "user_id"
    t.text     "ip_addr",     :limit => 255
    t.datetime "expiry"
    t.integer  "brute_force", :limit => 1,   :default => 0, :null => false
  end

  create_table "cpg1410_bridge", :primary_key => "name", :force => true do |t|
    t.string "value", :default => "", :null => false
  end

  add_index "cpg1410_bridge", ["name"], :name => "name", :unique => true

  create_table "cpg1410_categories", :primary_key => "cid", :force => true do |t|
    t.integer "owner_id",    :default => 0,  :null => false
    t.string  "name",        :default => "", :null => false
    t.text    "description",                 :null => false
    t.integer "pos",         :default => 0,  :null => false
    t.integer "parent",      :default => 0,  :null => false
    t.integer "thumb",       :default => 0,  :null => false
  end

  add_index "cpg1410_categories", ["owner_id"], :name => "cat_owner_id"
  add_index "cpg1410_categories", ["parent"], :name => "cat_parent"
  add_index "cpg1410_categories", ["pos"], :name => "cat_pos"

  create_table "cpg1410_comments", :primary_key => "msg_id", :force => true do |t|
    t.integer  "pid",           :limit => 3,   :default => 0,  :null => false
    t.string   "msg_author",    :limit => 25,  :default => "", :null => false
    t.text     "msg_body",                                     :null => false
    t.datetime "msg_date",                                     :null => false
    t.text     "msg_raw_ip",    :limit => 255
    t.text     "msg_hdr_ip",    :limit => 255
    t.string   "author_md5_id", :limit => 32,  :default => "", :null => false
    t.integer  "author_id",                    :default => 0,  :null => false
  end

  add_index "cpg1410_comments", ["pid"], :name => "com_pic_id"

  create_table "cpg1410_config", :primary_key => "name", :force => true do |t|
    t.string "value", :default => "", :null => false
  end

  create_table "cpg1410_dict", :primary_key => "keyId", :force => true do |t|
    t.string "keyword", :limit => 60, :default => "", :null => false
  end

  create_table "cpg1410_ecards", :primary_key => "eid", :force => true do |t|
    t.string "sender_name",     :limit => 50,  :default => "", :null => false
    t.text   "sender_email",                                   :null => false
    t.string "recipient_name",  :limit => 50,  :default => "", :null => false
    t.text   "recipient_email",                                :null => false
    t.text   "link",                                           :null => false
    t.text   "date",            :limit => 255,                 :null => false
    t.text   "sender_ip",       :limit => 255,                 :null => false
  end

  create_table "cpg1410_exif", :primary_key => "filename", :force => true do |t|
    t.text "exifData", :null => false
  end

  add_index "cpg1410_exif", ["filename"], :name => "filename", :unique => true

  create_table "cpg1410_favpics", :primary_key => "user_id", :force => true do |t|
    t.text "user_favpics", :null => false
  end

  create_table "cpg1410_filetypes", :primary_key => "extension", :force => true do |t|
    t.string "mime",    :limit => 30
    t.string "content", :limit => 15
    t.string "player",  :limit => 5
  end

  create_table "cpg1410_hit_stats", :primary_key => "sid", :force => true do |t|
    t.string  "pid",           :limit => 100, :default => "", :null => false
    t.string  "ip",            :limit => 20,  :default => "", :null => false
    t.string  "search_phrase",                :default => "", :null => false
    t.integer "sdate",         :limit => 8,   :default => 0,  :null => false
    t.text    "referer",                                      :null => false
    t.string  "browser",                      :default => "", :null => false
    t.string  "os",            :limit => 50,  :default => "", :null => false
  end

  create_table "cpg1410_pictures", :primary_key => "pid", :force => true do |t|
    t.integer  "aid",                           :default => 0,    :null => false
    t.string   "filepath",                      :default => "",   :null => false
    t.string   "filename",                      :default => "",   :null => false
    t.integer  "filesize",                      :default => 0,    :null => false
    t.integer  "total_filesize",                :default => 0,    :null => false
    t.integer  "pwidth",         :limit => 2,   :default => 0,    :null => false
    t.integer  "pheight",        :limit => 2,   :default => 0,    :null => false
    t.integer  "hits",                          :default => 0,    :null => false
    t.datetime "mtime",                                           :null => false
    t.integer  "ctime",                         :default => 0,    :null => false
    t.integer  "owner_id",                      :default => 0,    :null => false
    t.string   "owner_name",     :limit => 40,  :default => "",   :null => false
    t.integer  "pic_rating",                    :default => 0,    :null => false
    t.integer  "votes",                         :default => 0,    :null => false
    t.string   "title",                         :default => "",   :null => false
    t.text     "caption",                                         :null => false
    t.string   "keywords",                      :default => "",   :null => false
    t.string   "approved",       :limit => 0,   :default => "NO", :null => false
    t.integer  "galleryicon",                   :default => 0,    :null => false
    t.string   "user1",                         :default => "",   :null => false
    t.string   "user2",                         :default => "",   :null => false
    t.string   "user3",                         :default => "",   :null => false
    t.string   "user4",                         :default => "",   :null => false
    t.integer  "url_prefix",     :limit => 1,   :default => 0,    :null => false
    t.text     "pic_raw_ip",     :limit => 255
    t.text     "pic_hdr_ip",     :limit => 255
    t.text     "lasthit_ip",     :limit => 255
    t.integer  "position",                      :default => 0,    :null => false
  end

  add_index "cpg1410_pictures", ["aid", "approved"], :name => "aid_approved"
  add_index "cpg1410_pictures", ["aid"], :name => "pic_aid"
  add_index "cpg1410_pictures", ["hits"], :name => "pic_hits"
  add_index "cpg1410_pictures", ["owner_id"], :name => "owner_id"
  add_index "cpg1410_pictures", ["pic_rating"], :name => "pic_rate"
  add_index "cpg1410_pictures", ["title", "caption", "keywords", "filename"], :name => "search"

  create_table "cpg1410_plugins", :primary_key => "plugin_id", :force => true do |t|
    t.string  "name",     :limit => 64,  :default => "", :null => false
    t.string  "path",     :limit => 128, :default => "", :null => false
    t.integer "priority",                :default => 0,  :null => false
  end

  add_index "cpg1410_plugins", ["name"], :name => "name", :unique => true
  add_index "cpg1410_plugins", ["path"], :name => "path", :unique => true

  create_table "cpg1410_sessions", :primary_key => "session_id", :force => true do |t|
    t.integer "user_id",  :default => 0
    t.integer "time"
    t.integer "remember", :default => 0
  end

  create_table "cpg1410_temp_data", :primary_key => "unique_ID", :force => true do |t|
    t.binary  "encoded_string",                :null => false
    t.integer "timestamp",      :default => 0, :null => false
  end

  create_table "cpg1410_usergroups", :primary_key => "group_id", :force => true do |t|
    t.string  "group_name",                          :default => "", :null => false
    t.integer "group_quota",                         :default => 0,  :null => false
    t.integer "has_admin_access",       :limit => 1, :default => 0,  :null => false
    t.integer "can_rate_pictures",      :limit => 1, :default => 0,  :null => false
    t.integer "can_send_ecards",        :limit => 1, :default => 0,  :null => false
    t.integer "can_post_comments",      :limit => 1, :default => 0,  :null => false
    t.integer "can_upload_pictures",    :limit => 1, :default => 0,  :null => false
    t.integer "can_create_albums",      :limit => 1, :default => 0,  :null => false
    t.integer "pub_upl_need_approval",  :limit => 1, :default => 1,  :null => false
    t.integer "priv_upl_need_approval", :limit => 1, :default => 1,  :null => false
    t.integer "upload_form_config",     :limit => 1, :default => 3,  :null => false
    t.integer "custom_user_upload",     :limit => 1, :default => 0,  :null => false
    t.integer "num_file_upload",        :limit => 1, :default => 5,  :null => false
    t.integer "num_URI_upload",         :limit => 1, :default => 3,  :null => false
  end

  create_table "cpg1410_users", :primary_key => "user_id", :force => true do |t|
    t.integer  "user_group",                    :default => 2,    :null => false
    t.string   "user_active",     :limit => 0,  :default => "NO", :null => false
    t.string   "user_name",       :limit => 25, :default => "",   :null => false
    t.string   "user_password",   :limit => 40, :default => "",   :null => false
    t.datetime "user_lastvisit",                                  :null => false
    t.datetime "user_regdate",                                    :null => false
    t.string   "user_group_list",               :default => "",   :null => false
    t.string   "user_email",                    :default => "",   :null => false
    t.string   "user_profile1",                 :default => "",   :null => false
    t.string   "user_profile2",                 :default => "",   :null => false
    t.string   "user_profile3",                 :default => "",   :null => false
    t.string   "user_profile4",                 :default => "",   :null => false
    t.string   "user_profile5",                 :default => "",   :null => false
    t.text     "user_profile6",                                   :null => false
    t.string   "user_actkey",     :limit => 32, :default => "",   :null => false
  end

  add_index "cpg1410_users", ["user_name"], :name => "user_name", :unique => true

  create_table "cpg1410_vote_stats", :primary_key => "sid", :force => true do |t|
    t.string  "pid",     :limit => 100, :default => "", :null => false
    t.integer "rating",  :limit => 2,   :default => 0,  :null => false
    t.string  "ip",      :limit => 20,  :default => "", :null => false
    t.integer "sdate",   :limit => 8,   :default => 0,  :null => false
    t.text    "referer",                                :null => false
    t.string  "browser",                :default => "", :null => false
    t.string  "os",      :limit => 50,  :default => "", :null => false
  end

  create_table "cpg1410_votes", :id => false, :force => true do |t|
    t.integer "pic_id",      :limit => 3,  :default => 0,  :null => false
    t.string  "user_md5_id", :limit => 32, :default => "", :null => false
    t.integer "vote_time",                 :default => 0,  :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
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
