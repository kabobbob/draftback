class Petition < ActiveRecord::Base
  validates_presence_of :name, :email
  validates_email_format_of :email  
end
