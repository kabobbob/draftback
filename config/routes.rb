ActionController::Routing::Routes.draw do |map|
  map.resource :user_session

  map.resources :users

  map.resource :petition, :member => {:sign => :get, :submit => :post}

  map.manage  '/manage',  :controller => 'main', :action => 'manage'
  map.root    :controller => 'main', :action => 'index'
#  map.connect '',         :controller => 'main', :action => 'index'

  # Install the default routes as the lowest priority.
#  map.connect ':controller/:action
end
