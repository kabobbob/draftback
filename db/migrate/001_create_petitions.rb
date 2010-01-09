class CreatePetitions < ActiveRecord::Migration
  def self.up
    create_table :petitions do |t|
      t.column :full_name,      :string
      t.column :email_address,  :string
      t.column :location,       :string
      t.column :comments,       :text
      t.column :ip_address,     :string
      t.column :hide_email,     :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :petitions
  end
end
