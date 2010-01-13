class CommentsController < ApplicationController
  def create
    comment = Comment.new(params[:comment])
    comment.post_id = params[:post_id]
    
    if comment.save
    else
    end
    @comments = Post.find(params[:post_id]).comments
  end
end
