class AddColumnCommentsDisplay < ActiveRecord::Migration
  def self.up
    add_column :comments, :display, :boolean
  end

  def self.down
    remove_column :comments, :display
  end
end
