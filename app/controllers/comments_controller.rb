class CommentsController < ApplicationController
  def create
    comment = Comment.new(params[:comment])
    comment.post_id = params[:post_id]
    comment.save    
    
    @comments = Post.find(params[:post_id]).comments
  end
end
