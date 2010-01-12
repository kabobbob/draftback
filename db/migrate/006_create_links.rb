class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string  'title'
      t.text    'description'
      t.text    'url'
      t.boolean 'display'
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
