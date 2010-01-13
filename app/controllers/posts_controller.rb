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
      @post.update_attribute(:short_url, get_short_url(post_path(@post)))
      create_xml_feed
      tweet_post(@post)
      flash[:notice] = "Entry submitted!"
      redirect_to posts_path()
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
      tweet_this(@post)
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
    @comment = Comment.new()
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
  
  private
  def tweet_post(post)
    # create tweet
    title = post.title.length > 100 ? post.title.slice(0, 100) : post.title
    tweet = title + ' ... ' + post.short_url
    
    # send tweet
    tweet_this(tweet)
  end
end