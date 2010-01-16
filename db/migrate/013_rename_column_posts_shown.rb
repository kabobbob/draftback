class RenameColumnPostsShown < ActiveRecord::Migration
  def self.up
    rename_column :posts, :shown, :display
  end

  def self.down
    rename_column :posts, :display, :shown
  end
end
