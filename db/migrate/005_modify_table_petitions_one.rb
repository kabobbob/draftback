class ModifyTablePetitionsOne < ActiveRecord::Migration
  def self.up
    remove_column :petitions, :updated_at
    add_column :petitions, :display, :boolean
  end

  def self.down
    remove_column :petitions, :display
    add_column :pettions, :updated_at, :datetime
  end
end
