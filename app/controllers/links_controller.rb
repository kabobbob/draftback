class LinksController < ApplicationController
  before_filter :require_user, :only => [:manage, :new, :create, :show, :edit, :update, :toggle_displayed]
  
  def index
    @links = Link.find(:all, :conditions => ['display = ?', true], :order => 'id')
  end
  
  def manage
    @links = Link.find(:all, :order => 'id')
  end
  
  def new
    @link = Link.new()
  end
  
  def create
    @link = Link.new(params[:link])
    @link.user_id   = current_user.id  
    @link.short_url = get_short_url(@link.url)
    
    if @link.save
      create_xml_feed
      tweet_this(@link)
      flash[:notice] = "Link submitted!"
      redirect_to manage_links_path()      
    else
      render :action => "new"
    end
  end
  
  def edit
    @link = Link.find(params[:id])
  end
  
  def update
    @link = Link.find(params[:id])
    
    # update short url if link changes
    if @link.url != params[:link][:url]
      params[:link][:short_url] = get_short_url(params[:link][:url])
    end
    
    if @link.update_attributes(params[:link])
      create_xml_feed
      tweet_this(@post)
      flash[:notice] = "Entry updated!"
      redirect_to manage_links_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    Link.find(params[:id]).destroy
    redirect_to manage_links_path()
  end
  
  def toggle_displayed
    display = params[:checked] == "true" ? true : false
    link = Link.find(params[:id])
    link.update_attribute(:display, display)
    create_xml_feed
  end
  
  private
  def tweet_link(link)
    # create tweet
    title = link.title.length > 100 ? link.title.slice(0, 100) : link.title
    tweet = title + ' ... ' + link.short_url
    
    # send tweet
    tweet_this(tweet)
  end
end
