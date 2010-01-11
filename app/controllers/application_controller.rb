# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :get_recent_posts
  before_filter :get_archives
  
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  def get_recent_posts
    @recent_posts = Post.find(:all, 
      :conditions => ["shown = ?", true], 
      :order => "created_at desc", 
      :limit => 5
    )  
  end
  
  def get_archives
    @archives = Post.find(:all, 
      :select => "month(created_at) as month, monthname(created_at) as monthname, year(created_at) as year", 
      :conditions => ["shown = ?", true], 
      :group => "month(created_at), year(created_at)", 
      :order => "created_at desc"
    )  
  end
  
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
    store_location
    flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end
 
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to user_path(@current_user)
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def tweet_post(post)
    # create tweet
    tweet = "A new post has been created"
    http_auth = Twitter::HTTPAuth.new('givememydraftbk', 'wercool2')
    client = Twitter::Base.new(http_auth)
#    client.update()    
    y client.friends_timeline
  end
  
  def create_xml_feed
    # get posts
    posts = Post.find(:all, :conditions => ["shown = ?", true])
    
    # create feed
    version = "2.0"
    destination = "givememydraftback.com_feed.xml"
    
    content = RSS::Maker.make(version) do |m|
      m.channel.title = "Give Me My Draft Back!"
      m.channel.link = "http://givememydraftback.com"
      m.channel.description = "THE petition to get Commissioner Goodell to return the draft to the better format."
      m.items.do_sort = true # sort items by date
      
      posts.each{|post| 
        i = m.items.new_item
        i.title = post.title
        i.link = full_post_url(post.id)
        i.description = post.entry + "<p></p>" + post.signature
        i.date = Time.parse(post.created_at.strftime("%Y/%m/%d %I:%M"))
      }
    end
    
    File.open("public/" + destination,"w") do |f|
      f.write(content)
    end
  end
end
