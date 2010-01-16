# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :get_recent_posts
  before_filter :get_archives
  
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user, :prod_environment
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  def get_recent_posts
    @recent_posts = Post.find(:all, 
      :conditions => ["display = ?", true], 
      :order => "created_at desc", 
      :limit => 5
    )  
  end
  
  def get_archives
    @archives = Post.find(:all, 
      :select => "month(created_at) as month, monthname(created_at) as monthname, year(created_at) as year", 
      :conditions => ["display = ?", true], 
      :group => "month(created_at), year(created_at)", 
      :order => "created_at desc"
    )  
  end
  
  # return true if prod env
  def prod_environment
    ENV['RAILS_ENV'] == 'production'
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
  
  def tweet_this(tweet)
    # generate twitter obj
    http_auth = Twitter::HTTPAuth.new('givememydraftbk', 'wercool2')
    twitter_obj = Twitter::Base.new(http_auth)
    
    # send tweet
    if prod_environment
      twitter_obj.update(tweet)
    end
  end

  def get_short_url(url)
    # generate bit.ly object
    authorize = UrlShortener::Authorize.new 'givememydraftbk', 'R_091d91e2c73bb067bec83e759b9e1b70'
    client = UrlShortener::Client.new(authorize)

    # use bit.ly to shorten url
    short_url = client.shorten(url)
    short_url.urls    
  end
  
  def create_xml_feed
    # get posts
    posts = Post.find(:all, :conditions => ["display = ?", true])
    links = Link.find(:all, :conditions => ["display = ?", true])
    
    # create feed array
    feed_array = Array.new()
    posts.each{|post|
      tmp_hash = {
        :title        => post.title,
        :link         => post_url(post.id),
        :description  => post.entry,
        :date         => post.created_at,
        :signature    => post.signature
      }
      feed_array.push(tmp_hash)
    }
    
    links.each{|link|
      desc_link = "<a href='#{link.url}' target='_blank'>#{link.url}</a>"
      tmp_hash = {
        :title        => 'New Link Posted',
        :link         => links_url(),
        :description  => link.description + '<br/>' + desc_link,
        :date         => link.created_at,
        :signature    => ''
      }
      feed_array.push(tmp_hash)
    }
    
    feed_array.sort!{|a,b| b[:date] <=> a[:date]}
    
    # create feed
    version = "2.0"
    destination = "givememydraftback.com_feed.xml"
    
    content = RSS::Maker.make(version) do |m|
      m.channel.title = "Give Me My Draft Back!"
      m.channel.link = "http://givememydraftback.com"
      m.channel.description = "THE petition to get Commissioner Goodell to return the draft to the better format."
      m.items.do_sort = true # sort items by date
      
      feed_array.each{|feed_item| 
        i              = m.items.new_item
        i.title        = feed_item[:title]
        i.link         = feed_item[:link]
        i.description  = feed_item[:description]
        i.description += "<p><p>" + feed_item[:signature] unless feed_item[:signature].empty?
        i.date         = Time.parse(feed_item[:date].strftime("%Y/%m/%d %I:%M"))
      }
    end
    
    File.open("public/" + destination,"w") do |f|
      f.write(content)
    end
  end
end
