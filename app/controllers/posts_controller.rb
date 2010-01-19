class PostsController < ApplicationController
  before_filter :require_user, :except => [:show, :archive]
  
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
      @post.update_attribute(:short_url, get_short_url(post_url(@post)))
      create_xml_feed
      send_post(@post)
      redirect_to posts_path()
    else
      render :action => "new"
    end
  end
  
  def show
    @post = Post.find(:first, :conditions => ["id = ? and display = ?", params[:id], true])
    @comment = Comment.new()
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      create_xml_feed
      send_post(@post)
      redirect_to :action => 'full'
    else
      render :action => :edit
    end
  end
  
  def destroy
    Post.find(params[:id]).destroy
    redirect_to posts_path
  end
  
  def full
    @post = Post.find(params[:id])
  end
  
  def toggle_displayed
    display = params[:checked] == "true" ? true : false
    post = Post.find(params[:id])
    post.update_attribute(:display, display)
    create_xml_feed
  end
  
  def archive
    conditions = ""
    if params[:month] and params[:year]
      conditions = ["month(created_at) = ? and year(created_at) = ? and display = ?", params[:month], params[:year], true]
    end
    
    @posts = Post.find(:all, :conditions => conditions, :order => "created_at desc") 
  end
  
  private
  def send_post(post)
    # tweet post
    title = post.title.length > 100 ? post.title.slice(0, 100) : post.title
    tweet = title + ' ... ' + post.short_url
    tweet_this(tweet)
    
    # facebook post
    message = "New Post!"
    attachment = {
      :href         => post_url(post), 
      :name         => post.title, 
      :description  => strip_tags(post.entry)
    }
   
    fb_this(message, attachment)
  end
end