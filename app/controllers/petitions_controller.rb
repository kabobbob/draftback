class PetitionsController < ApplicationController
  before_filter :require_user, :only => [:manage, :toggle_displayed]
  
  def show
    # get no more than last 5 signatures
    @signatures = Petition.find(:all, :conditions => ['display = ?', true], :order => 'id desc', :limit => 5)
    @index      = Petition.count(:conditions => ['display = ?', true])
    @message    = params[:message] ? params[:message] : ''
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
    @signatures = Petition.find(:all, :conditions => ['display = ?', true], :order => 'id desc')
    @index      = @signatures.length
  end
  
  def manage
    @signatures = Petition.find(:all, :order => 'id desc')
  end
  
  def toggle_displayed
    display = params[:checked] == "true" ? true : false
    signature = Petition.find(params[:id])
    signature.update_attribute(:display, display)
  end
end
