class RenameColumnsPetitions1 < ActiveRecord::Migration
  def self.up
    rename_column :petitions, :full_name, :name
    rename_column :petitions, :email_address, :email
  end

  def self.down
    rename_column :petitions, :email, :email_address
    rename_column :petitions, :name, :full_name
  end
end
