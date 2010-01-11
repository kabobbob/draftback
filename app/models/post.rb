class Post < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :title, :entry, :signature
  def before_create
    self.shown = true
  end
end
