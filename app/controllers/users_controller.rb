class UsersController < ApplicationController
  before_filter :require_user, :only => [:index, :new, :create, :show, :edit, :update]
  
  def index
    @users = User.find(:all)  
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "User registered!"
      redirect_back_or_default users_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
 
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated!"
      redirect_to users_url
    else
      render :action => :edit
    end
  end
end
