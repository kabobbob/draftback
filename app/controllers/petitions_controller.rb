class PetitionsController < ApplicationController
  before_filter :require_user, :only => [:manage, :toggle_displayed]
  
  def show
    # get no more than last 5 signatures
    @num_signatures = Petition.count(:conditions => ['display = ?', true])
    offset          = @num_signatures > 5 ? @num_signatures - 5 : 0
    @petitions      = Petition.find(:all, :conditions => ['display = ?', true], :order => 'id desc', :offset => offset)
    @message        = params[:message] ? params[:message] : ''
  end
  
  def sign
    # store referer
    session[:http_referer] = request.env['HTTP_REFERER']
    @petition = Petition.new()
    @message = ''    
  end
  
  def submit
    # get user env vars
    params[:petition][:ip_address]    = request.env['REMOTE_ADDR']
    params[:petition][:user_agent]    = request.env['HTTP_USER_AGENT']
    params[:petition][:http_referer]  = session[:http_referer]
    params[:petition][:display]       = true
    
    # save signature
    @petition = Petition.new(params[:petition])
    if @petition.save
      redirect_to :action => 'show', :message => 'Thank you for your signature!' 
    else
      @message = "There are errors in your signature, please see below."
      render :action => 'sign'
    end
  end
  
  def signatures
    page = params[:page] ? params[:page].to_i : 1
    @petitions = Petition.paginate :page => page, :per_page => 15, :conditions => ['display = ?', true], :order => 'id desc'
    
    # get signature indexing
    @num_signatures = Petition.count(:conditions => ['display = ?', true])
  end
  
  def manage
    page = params[:page] ? params[:page] : 1
    @signatures = Petition.paginate :page => page, :per_page => 20, :order => 'id desc'
  end
  
  def toggle_displayed
    display = params[:checked] == "true" ? true : false
    signature = Petition.find(params[:id])
    signature.update_attribute(:display, display)
  end
end
