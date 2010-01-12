class Petition < ActiveRecord::Base
  validates_presence_of :full_name, :email_address
  validates_email_format_of :email_address  
end
