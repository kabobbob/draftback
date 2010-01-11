class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer  "user_id",                    :null => false
      t.text     "title",                      :null => false
      t.string   "entry",      :limit => 4000, :null => false
      t.string   "signature",                  :null => false
      t.boolean  "shown",                      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
