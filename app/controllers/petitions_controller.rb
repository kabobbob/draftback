class PetitionsController < ApplicationController
  def show
    @petitions = Petition.find(:all)
  end
  
  def sign
    @petition = Petition.new()
  end
  
  def submit
    petition = Petition.create(params[:petition])
    redirect_to :action => 'show'
  end
end
