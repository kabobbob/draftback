class PostsController < ApplicationController
  before_filter :require_user, :only => [:index, :new, :create, :show, :edit, :update, :toggle_displayed]
  
  def index
    @posts = Post.find(:all, :order => "created_at desc")
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    
    if @post.save
      create_xml_feed
      tweet_post(@post, 'new')
      flash[:notice] = "Entry submitted!"
      redirect_to posts_path      
    else
      render :action => "new"
    end
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      create_xml_feed
      tweet_post(@post, 'update')
      flash[:notice] = "Entry updated!"
      redirect_to post_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    Post.find(params[:id]).destroy
    redirect_to posts_path
  end
  
  def full
    @post = Post.find(:first, :conditions => ["id = ? and shown = ?", params[:id], true])
  end
  
  def toggle_displayed
    shown = params[:checked] == "true" ? true : false
    post = Post.find(params[:id])
    post.update_attribute(:shown, shown)
    create_xml_feed
  end
  
  def archive
    conditions = ""
    if params[:month] and params[:year]
      conditions = ["month(created_at) = ? and year(created_at) = ?", params[:month], params[:year]]
    end
    
    @posts = Post.find(:all, :conditions => conditions, :order => "created_at desc") 
  end
end
