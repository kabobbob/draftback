class Comment < ActiveRecord::Base
  belongs_to :post
  
  validates_presence_of :name, :email, :comment
  validates_email_format_of :email
end
