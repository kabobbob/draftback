class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  validates_presence_of :title, :entry, :signature
  
  def before_create
    self.display = true
  end
  
  def allowed_comments
    self.comments.find(:all, :conditions => ['display = ?', true], :order => 'id desc')
  end
end
