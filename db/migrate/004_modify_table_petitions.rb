class ModifyTablePetitions < ActiveRecord::Migration
  def self.up
    remove_column :petitions, :hide_email
    add_column :petitions, :user_agent, :string
    add_column :petitions, :http_referer, :string
  end

  def self.down
    remove_column :petitions, :http_referer
    remove_column :petitions, :user_agent
    add_column :petition, :hide_email, :boolean
  end
end
