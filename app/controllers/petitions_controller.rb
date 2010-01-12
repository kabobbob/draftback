class PetitionsController < ApplicationController
  def show
    # get no more than last 5 signatures
    @num_signatures = Petition.count(:conditions => ['display = ?', true])
    offset          = @num_signatures > 5 ? @num_signatures - 5 : 0
    @petitions      = Petition.find(:all, :conditions => ['display = ?', true], :order => 'id desc', :offset => offset)
  end
  
  def sign
    # store referer
    session[:http_referer] = request.env['HTTP_REFERER']
    @petition = Petition.new()
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
      redirect_to :action => 'show'
    else
      render :action => 'sign'
    end
  end
  
  def signatures
    page      = params[:page] ? params[:page].to_i : 1
    per_page  = 15
    @petitions = Petition.paginate :page => page, :per_page => per_page, :conditions => ['display = ?', true], :order => 'id desc'
    
    # get signature indexing
    @num_signatures = Petition.count(:conditions => ['display = ?', true])
  end
  
  def manage
    
  end
end
