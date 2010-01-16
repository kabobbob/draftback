class CommentsController < ApplicationController
  before_filter :require_user, :only => [:toggle_displayed]
  
  def create
    @saved = false
    comment = Comment.new(params[:comment])
    comment.post_id = params[:post_id]
    comment.display = true
    
    if comment.save    
      @comments = Post.find(params[:post_id]).allowed_comments
      @saved    = true
    end
  end
  
  def toggle_displayed
    display = params[:checked] == "true" ? true : false
    comment = Comment.find(params[:id])
    comment.update_attribute(:display, display)
  end
end
