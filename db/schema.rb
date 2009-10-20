# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091019212749) do

  create_table "categories", :force => true do |t|
    t.integer  "parent_id",                  :default => 0
    t.string   "name",        :limit => 50
    t.string   "permalink",   :limit => 50
    t.string   "description", :limit => 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_entries", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "entry_id"
    t.string   "author"
    t.string   "user_ip"
    t.string   "author_url"
    t.string   "author_email"
    t.string   "content"
    t.datetime "deleted_at"
    t.string   "user_agent",   :limit => 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.string   "user_id"
    t.string   "title",          :limit => 250
    t.string   "permalink",      :limit => 250
    t.datetime "publish_at"
    t.string   "content"
    t.string   "content_parsed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "forum_thread_id"
    t.integer  "forum_id"
    t.text     "body"
    t.text     "body_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_posts", ["created_at", "forum_id"], :name => "index_forum_posts_on_forum_id"
  add_index "forum_posts", ["created_at", "forum_thread_id"], :name => "index_forum_posts_on_thread_id"
  add_index "forum_posts", ["created_at", "user_id"], :name => "index_forum_posts_on_user_id"

  create_table "forum_threads", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.integer  "hits",               :default => 0
    t.integer  "sticky",             :default => 0
    t.integer  "forum_posts_count",  :default => 0
    t.boolean  "locked",             :default => false
    t.integer  "last_forum_post_id"
    t.datetime "last_updated_at"
    t.integer  "last_user_id"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_threads", ["forum_id", "permalink"], :name => "index_forum_threads_on_forum_id_and_permalink"
  add_index "forum_threads", ["last_updated_at", "forum_id"], :name => "index_forum_threads_on_forum_id_and_last_updated_at"
  add_index "forum_threads", ["sticky", "last_updated_at", "forum_id"], :name => "index_forum_threads_on_sticky_and_last_updated_at"

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.text    "description_html"
    t.string  "state",               :default => "public"
    t.string  "permalink"
    t.integer "position",            :default => 0
    t.integer "forum_threads_count", :default => 0
    t.integer "forum_posts_count",   :default => 0
  end

  add_index "forums", ["permalink"], :name => "index_forums_on_permalink"
  add_index "forums", ["position"], :name => "index_forums_on_position"

  create_table "links", :force => true do |t|
    t.string   "name",       :limit => 50
    t.string   "url",        :limit => 100
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "role_users", ["role_id"], :name => "index_roles"
  add_index "role_users", ["user_id"], :name => "index_users"

  create_table "roles", :force => true do |t|
    t.string "slug"
    t.string "name"
    t.text   "description"
  end

  create_table "tag_entries", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name",        :limit => 50
    t.string   "permalink",   :limit => 50
    t.string   "description", :limit => 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.boolean  "admin",                                   :default => false
    t.datetime "last_login_at"
    t.text     "bio_html"
    t.string   "openid_url"
    t.datetime "last_seen_at"
    t.string   "website"
    t.integer  "forum_posts_count",                       :default => 0
    t.string   "bio"
    t.string   "display_name"
    t.string   "permalink"
  end

  add_index "users", ["forum_posts_count"], :name => "index_users_on_forum_posts_count"
  add_index "users", ["last_seen_at"], :name => "index_users_on_last_seen_at"
  add_index "users", ["permalink"], :name => "index_users_on_permalink"

end
