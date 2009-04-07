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

ActiveRecord::Schema.define(:version => 20090404170416) do

  create_table "categories", :force => true do |t|
    t.integer  "parent_id",                  :default => 0
    t.string   "name",        :limit => 50
    t.string   "permalink",   :limit => 50
    t.string   "description", :limit => 300
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_entries", :force => true do |t|
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.string   "alias"
    t.string   "ip"
    t.string   "website"
    t.string   "email"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "user_id"
    t.string   "title",          :limit => 250
    t.string   "permalink",      :limit => 250
    t.datetime "publish_at"
    t.string   "content"
    t.string   "content_parsed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_entries", :force => true do |t|
    t.integer  "post_id"
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

end
