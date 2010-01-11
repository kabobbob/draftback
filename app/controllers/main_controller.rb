class MainController < ApplicationController
  def index
    @post = Post.find(:first, :conditions => ["shown = ?", true], :order => "created_at desc")
  end
  
  def manage
    
  end
  
  def contact
    
  end
end