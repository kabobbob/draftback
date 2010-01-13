class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  validates_presence_of :title, :entry, :signature
  
  def before_create
    self.shown = true
  end
end
