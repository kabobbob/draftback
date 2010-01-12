class Link < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :title, :url
  
  def before_create
    self.display = true
  end
end
