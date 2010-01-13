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

ActiveRecord::Schema.define(:version => 10) do

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.string   "name"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "url"
    t.boolean  "display"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_url"
    t.integer  "user_id"
  end

  create_table "petitions", :force => true do |t|
    t.string   "full_name"
    t.string   "email_address"
    t.string   "location"
    t.text     "comments"
    t.string   "ip_address"
    t.datetime "created_at"
    t.string   "user_agent"
    t.string   "http_referer"
    t.boolean  "display"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.text     "title",                      :null => false
    t.string   "entry",      :limit => 4000, :null => false
    t.string   "signature",                  :null => false
    t.boolean  "shown",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_url"
  end

  create_table "users", :force => true do |t|
    t.string   "login",             :null => false
    t.string   "email",             :null => false
    t.string   "first_name",        :null => false
    t.string   "last_name",         :null => false
    t.string   "crypted_password",  :null => false
    t.string   "password_salt",     :null => false
    t.string   "persistence_token", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
