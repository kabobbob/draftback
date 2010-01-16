class MainController < ApplicationController
  def index
    @post = Post.find(:first, :conditions => ["display = ?", true], :order => "created_at desc")
  end
  
  def contact
    
  end
end